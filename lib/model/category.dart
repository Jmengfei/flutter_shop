class CategoryModel{
  String mallCategoryId; // 类别编号
  String mallCategoryName; // 类别名称
  List<dynamic> bxMallSubDto; // 子类模型
  Null comments;
  String image;

  CategoryModel({
    this.mallCategoryId,
    this.mallCategoryName,
    this.bxMallSubDto,
    this.comments,
    this.image
  });

  // 工厂构造方法
  factory CategoryModel.fromJson(dynamic json){
    return CategoryModel(
        mallCategoryId: json['mallCategoryId'],
        mallCategoryName: json['mallCategoryName'],
        bxMallSubDto: json['bxMallSubDto'],
        comments: json['comments'],
        image: json['image']
    );
  }
}

class CategoryListModel{
  List<CategoryModel> data;

  CategoryListModel(this.data);

  factory CategoryListModel.fromJson(List json){
    return CategoryListModel(
      json.map((i)=> CategoryModel.fromJson(i)).toList()
    );
  }
}
