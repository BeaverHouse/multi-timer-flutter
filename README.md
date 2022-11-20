# multi_timer_flutter

A new Flutter project.

## Notes
Android Only

## Build (Android)
```
flutter build apk --split-per-abi
```

## Bug Fix
앱 기록에서도 앱을 지우고 알림이 왔을 때 알림이 해제되지 않음   
=> 현재 시간 이전의 알람 완료 시각은 반영하지 않도록 변경함