import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_config/firebase_config.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:stories_repository/stories_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'create_stories_event.dart';
part 'create_stories_state.dart';

class CreateStoriesBloc extends Bloc<CreateStoriesEvent, CreateStoriesState> {
  CreateStoriesBloc({
    required StoriesRepository storiesRepository,
    required FirebaseConfig remoteConfig,
  })  : _storiesRepository = storiesRepository,
        _remoteConfig = remoteConfig,
        super(const CreateStoriesState.intital()) {
    on<CreateStoriesStoryCreateRequested>(_onStoryCreateRequested);
    on<CreateStoriesStoryDeleteRequested>(_onStoryDeleteRequested);
    on<CreateStoriesFeatureAvaiableSubscriptionRequested>(
      _onCreateStoriesFeatureAvaiableSubscriptionRequested,
    );
  }

  final StoriesRepository _storiesRepository;
  final FirebaseConfig _remoteConfig;

  Future<void> _onCreateStoriesFeatureAvaiableSubscriptionRequested(
    CreateStoriesFeatureAvaiableSubscriptionRequested event,
    Emitter<CreateStoriesState> emit,
  ) async {
    final storiesEnabled =
        _remoteConfig.isFeatureAvailabe('enable_create_stories');
    emit(state.copyWith(isAvailable: storiesEnabled));

    await emit.onEach(
      _remoteConfig.onConfigUpdated(),
      onData: (data) {
        _remoteConfig.activate();

        final storiesEnabled =
            _remoteConfig.isFeatureAvailabe('enable_create_stories');

        emit(state.copyWith(isAvailable: !storiesEnabled));
      },
    );
  }

  Future<void> _onStoryCreateRequested(
    CreateStoriesStoryCreateRequested event,
    Emitter<CreateStoriesState> emit,
  ) async {
    try {
      event.onLoading?.call();

      final storyId = UidGenerator.v4();
      final storyImageFile = File(event.filePath);
      final storyImageBytes = await PickImage.imageBytes(file: storyImageFile);
      final contentUrl = await _storiesRepository.uploadStoryMedia(
        storyId: storyId,
        imageFile: storyImageFile,
        imageBytes: storyImageBytes,
      );

      await _storiesRepository.createStory(
        id: storyId,
        author: event.author,
        contentType: event.contentType,
        contentUrl: contentUrl,
        duration: event.duration,
      );

      event.onStoryCreated?.call();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      event.onError?.call(error, stackTrace);
    }
  }

  Future<void> _onStoryDeleteRequested(
    CreateStoriesStoryDeleteRequested event,
    Emitter<CreateStoriesState> emit,
  ) async {
    try {
      await _storiesRepository.deleteStory(id: event.id);
      
      event.onStoryDeleted?.call();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}