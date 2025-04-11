
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../data/models/news_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleDetailScreen {
  static void show(BuildContext context, Article article) {
    final FlutterTts flutterTts = FlutterTts();
    final AudioPlayer audioPlayer = AudioPlayer();
    bool isTtsPlaying = false;
    bool isStreamPlaying = false;
    List<Map<String, String>> audioChannels = [];
    String? selectedStreamUrl;

    Future<void> initTts() async {
      try {
        await flutterTts.setLanguage('en-US');
        await flutterTts.setPitch(1.0);
        flutterTts.setCompletionHandler(() {
          isTtsPlaying = false;
          (context as Element).markNeedsBuild();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('TTS Setup Failed: $e')),
        );
      }
    }

    Future<void> fetchAudioChannels() async {
      try {
        final domain = article.domain?.split('.').first ?? 'news';
        final response = await http.get(
           // Uri.parse('https://nl1.api.radio-browser.info/json/stations/search?name=$domain&tag=news&limit=5')
            Uri.parse('https://all.api.radio-browser.info/json/stations/search?name=$domain&tag=news&limit=5')
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          audioChannels = data.map((station) => {
            'name': station['name'] as String,
            'url': station['url_resolved'] as String,
          }).toList();
        } else {
          audioChannels = [{'name': 'No channels found', 'url': ''}];
        }
      } catch (e) {
        audioChannels = [{'name': 'Error fetching channels: $e', 'url': ''}];
      }
      (context as Element).markNeedsBuild();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  controller: controller,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40.w,
                            height: 4.h,
                            margin: EdgeInsets.only(bottom: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                        Text(
                          article.title,
                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              article.domain,
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              _formatDate(article.date),
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        if (article.image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              article.image!,
                              width: double.infinity,
                              height: 200.h,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.error),
                            ),
                          ),
                        SizedBox(height: 16.h),
                        Text(
                          'This is a mock summary of the article since full content isn’t available from the Kite API.',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: isTtsPlaying
                                  ? null
                                  : () async {
                                await initTts();
                                final textToRead = '${article.title}. This is a mock summary...';
                                await flutterTts.speak(textToRead);
                                setState(() => isTtsPlaying = true);
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Play TTS'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            ElevatedButton.icon(
                              onPressed: isTtsPlaying
                                  ? () async {
                                await flutterTts.stop();
                                setState(() => isTtsPlaying = false);
                              }
                                  : null,
                              icon: const Icon(Icons.stop),
                              label: const Text('Stop TTS'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            IconButton(
                              icon: const Icon(Icons.radio),
                              tooltip: 'Audio Channels',
                              onPressed: () async {
                                if (audioChannels.isEmpty) await fetchAudioChannels();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Available Audio Channels'),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: audioChannels.length,
                                        itemBuilder: (context, index) {
                                          final channel = audioChannels[index];
                                          return ListTile(
                                            title: Text(channel['name']!),
                                            onTap: channel['url']!.isNotEmpty
                                                ? () async {
                                              try {
                                                if (isStreamPlaying) {
                                                  await audioPlayer.stop();
                                                  setState(() => isStreamPlaying = false);
                                                }
                                                selectedStreamUrl = channel['url'];
                                                await audioPlayer.play(UrlSource(selectedStreamUrl!));

                                                setState(() => isStreamPlaying = true);
                                                Navigator.pop(context);
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Audio Error: $e')),
                                                );
                                              }
                                            }
                                                : null,
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                      if (isStreamPlaying)
                                        TextButton(
                                          onPressed: () async {
                                            await audioPlayer.stop();
                                            setState(() => isStreamPlaying = false);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Stop Stream'),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        if (isStreamPlaying && selectedStreamUrl != null)
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              'Playing: ${audioChannels.firstWhere((ch) => ch['url'] == selectedStreamUrl)['name']}',
                              style: TextStyle(fontSize: 14.sp, color: Colors.green),
                            ),
                          ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).whenComplete(() async {
      await flutterTts.stop();
      await audioPlayer.stop();
    });
  }

  static String _formatDate(String? date) {
    if (date == null) return 'Unknown Date';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }
}