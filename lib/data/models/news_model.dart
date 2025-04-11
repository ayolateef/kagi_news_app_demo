class CategoryModel {
  int? timestamp;
  List<Categories>? categories;

  CategoryModel({this.timestamp, this.categories});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['timestamp'] = timestamp;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? name;
  String? file;

  Categories({this.name, this.file});

  Categories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['file'] = file;
    return data;
  }
}

class NewsClusterResponse {
  String? category;
  int? timestamp;
  int? read;
  List<Cluster>? clusters;

  NewsClusterResponse({this.category, this.timestamp, this.read, this.clusters});

  NewsClusterResponse.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    timestamp = json['timestamp'];
    read = json['read'];
    if (json['clusters'] != null) {
      clusters = <Cluster>[];
      json['clusters'].forEach((v) {
        clusters!.add(Cluster.fromJson(v));
      });
    }
  }
}

class Cluster {
  int? clusterNumber;
  int? uniqueDomains;
  int? numberOfTitles;
  String? category;
  String? title;
  String? shortSummary;
  List<Article>? articles;

  Cluster({
    this.clusterNumber,
    this.uniqueDomains,
    this.numberOfTitles,
    this.category,
    this.title,
    this.shortSummary,
    this.articles,
  });

  Cluster.fromJson(Map<String, dynamic> json) {
    clusterNumber = json['cluster_number'];
    uniqueDomains = json['unique_domains'];
    numberOfTitles = json['number_of_titles'];
    category = json['category'];
    title = json['title'];
    shortSummary = json['short_summary'];
    if (json['articles'] != null) {
      articles = <Article>[];
      json['articles'].forEach((v) {
        articles!.add(Article.fromJson(v));
      });
    }
  }
}

class Article {
  final String title;
  final String link;
  final String domain;
  final String date;
  final String? image;
  final String? imageCaption;

  Article({
    required this.title,
    required this.link,
    required this.domain,
    required this.date,
    this.image,
    this.imageCaption,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      domain: json['domain'] ?? '',
      date: json['date'] ?? '',
      image: json['image'],
      imageCaption: json['image_caption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'domain': domain,
      'date': date,
      'image': image,
      'image_caption': imageCaption,
    };
  }
}