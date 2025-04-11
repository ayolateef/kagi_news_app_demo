import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kagi_news_app_demo/data/models/news_model.dart';


class CategorySelector extends StatelessWidget {
  final List<Categories> categories;
  final String? selectedCategoryFile;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategoryFile,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedCategoryFile == category.file;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: GestureDetector(
            onTap: () => onCategorySelected(category.file!),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                // border: Border.all(
                //   color: isSelected
                //       ? Theme.of(context).colorScheme.primary
                //       : Colors.grey,
                //   width: 1.w,
                // ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:  18.w),
                child: Center(
                  child: Text(
                    category.name ?? 'Unnamed',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}