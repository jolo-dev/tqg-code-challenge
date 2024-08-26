import { GetObjectCommand, PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
const s3 = new S3Client();

export async function handler(event) {
    const sourceBucket = event.Records[0].s3.bucket.name;
    const sourceKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
    
    const destinationBucket = process.env.DESTINATION_BUCKET;
    const destinationPrefix = process.env.DESTINATION_PREFIX || '';
    
    try {
        const params = {
            Bucket: sourceBucket,
            Key: sourceKey,
        };
        
        const getObjectCommand = new GetObjectCommand(params);

        const { Body } = await s3.send(getObjectCommand);
        let stateFile = Body ? JSON.parse(Body.toString()) : new Error('No body found in the state file');
        
        // Strip resource information (example: keep only aws_s3_bucket and aws_lambda_function)
        stateFile.resources = stateFile.resources.filter(resource => {
            return ['aws_s3_bucket', 'aws_lambda_function'].includes(resource.type);
        });
        
        const destinationKey = `${destinationPrefix}${sourceKey}`;
        
        const putObjectCommand = new PutObjectCommand({
            Bucket: destinationBucket,
            Key: destinationKey,
            Body: JSON.stringify(stateFile),
        })
        await s3.send(putObjectCommand);
        
        console.log(`Processed ${sourceKey} and saved to ${destinationBucket}/${destinationKey}`);
    } catch (error) {
        console.error(`Error processing ${sourceKey}: `, error);
        throw error;
    }
}
