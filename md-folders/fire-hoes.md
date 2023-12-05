# Kinesis Firehoes

## Firehoes

![firehoes](../public/firehose.md)

- 기존 Kinesis DataStream의 Producer를 Lambda로 둘수있지만, 중복이 발생할 수있다.
- 여러가지 부분에서 문제가 많기때문에 왠만하면 DataStream -> Firehoes로 진행한다.
- Firehoes로도 DataStream의 역할이 가능하긴 하지만, 대용량 데이터로써는 Buffer의 역할이 부족하다
- Buffering 역할을 60초 ~ 5분까지 설정할 수 있다.
- 요청당 최대 500개 레코드까지 or 요청당 메가바이트까지 가능하다

## Capacitty

- 최대 5000개의 Record, 초당 2000개의 요청 또는 초당 5MB 처리 (최대한 5/1 수준으로 잡아야 Best Case)
- 결론적으로, 레코드 당 최대 페이로드는 1MB
