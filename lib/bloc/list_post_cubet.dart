import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/post_model.dart';
import '../pages/create_page.dart';
import '../service/dio_service.dart';
import 'list_post_state.dart';

class ListPostCubit extends Cubit<ListPostState> {
  ListPostCubit() : super(ListPostInit());

  void apiPostList() async {
    emit(ListPostLoading());

    var response = await Network.GET(Network.BASE + Network.API_LIST); //     print(response);

    if (response != null) {
      emit(ListPostLoaded(posts: Network.parsePostList(response), isDeleted: null));
    } else {
      emit(ListPostError(error: "Couldn't fetch posts"));
    }
  }

  void apiPostDelete(Post post) async {
    emit(ListPostLoading());

    var response = await Network.DEL(Network.BASE + Network.API_DELETE + post.id.toString());
    print(response);

    if (response != null) {
      apiPostList();
    } else {
      emit(ListPostError(error: "Couldn't delete post"));
    }
  }

  void callCreatePage(BuildContext context) async {
    var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreatePage(key: null,)));
    if (result != null) {
      BlocProvider.of<ListPostCubit>(context).apiPostList();
    }
  }
}