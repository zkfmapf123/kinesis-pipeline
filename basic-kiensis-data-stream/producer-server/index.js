import AWS from 'aws-sdk'
import { v4 as uuidv4 } from 'uuid'

AWS.config.update({ region: 'ap-northeast-2' })
const agent = new AWS.Kinesis()
const STREAM_NAME = 'my-console-stream'

const loadToMockJsonData = () => {
  const jsonData = {}
  for (let i = 0; i <= 100; i++) {
    jsonData[i] = {
      orderId: uuidv4(),
      customerID: `C${i}`,
      sellerID: `S${i}`,
      orderItems: [
        {
          productName: 'Hair',
          productCode: `A00${i}`,
          productQuantity: i,
          productPrice: i,
        },
      ],
    }
  }

  return jsonData
}

const putRecordsToKinesis = ([order, value]) => {
  const params = {
    Data: JSON.stringify(value),
    PartitionKey: value.orderId,
    SequenceNumberForOrdering: order,
    StreamName: STREAM_NAME,
  }

  agent.putRecord(params, (err, data) => {
    if (err) {
      throw new Error(err.message)
    }

    console.log('Successfully put record : ', data)
  })
}

;(() => {
  const data = loadToMockJsonData()
  // load
  for (const _data of Object.entries(data)) {
    putRecordsToKinesis(_data)
  }

  // simplePutRecord()
})()
