const fs = require('fs');
const path = require('path');
const https = require('https');

// 百度OCR配置 - 需要用户配置
let config = {
  api_key: process.env.BAIDU_OCR_API_KEY || '',
  secret_key: process.env.BAIDU_OCR_SECRET_KEY || ''
};

// 尝试读取配置文件
const configPath = path.join(__dirname, 'config.json');
if (fs.existsSync(configPath)) {
  try {
    const fileConfig = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    config = { ...config, ...fileConfig };
  } catch (e) {
    // ignore
  }
}

// 获取access_token
async function getAccessToken(apiKey, secretKey) {
  return new Promise((resolve, reject) => {
    const url = `https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=${apiKey}&client_secret=${secretKey}`;
    
    https.get(url, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.access_token) {
            resolve(json.access_token);
          } else {
            reject(new Error(json.error_description || 'Failed to get access token'));
          }
        } catch (e) {
          reject(e);
        }
      });
    }).on('error', reject);
  });
}

// 调用OCR API
async function recognizeImage(imagePath, accessToken) {
  return new Promise((resolve, reject) => {
    // 读取图片并转base64
    const imageBuffer = fs.readFileSync(imagePath);
    const imageBase64 = imageBuffer.toString('base64');
    
    const postData = `image=${encodeURIComponent(imageBase64)}`;
    
    const options = {
      hostname: 'aip.baidubce.com',
      path: `/rest/2.0/ocr/v1/general_basic?access_token=${accessToken}`,
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(postData)
      }
    };
    
    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.words_result) {
            resolve(json.words_result.map(item => item.words).join('\n'));
          } else if (json.error_msg) {
            reject(new Error(json.error_msg));
          } else {
            reject(new Error('Unknown OCR error'));
          }
        } catch (e) {
          reject(e);
        }
      });
    });
    
    req.on('error', reject);
    req.write(postData);
    req.end();
  });
}

// 主函数
async function main() {
  const args = process.argv.slice(2);
  
  if (args.length === 0) {
    console.log('Usage: node index.js <image_path>');
    console.log('\nEnvironment variables:');
    console.log('  BAIDU_OCR_API_KEY    - Baidu AI Platform API Key');
    console.log('  BAIDU_OCR_SECRET_KEY - Baidu AI Platform Secret Key');
    process.exit(1);
  }
  
  const imagePath = args[0];
  
  if (!fs.existsSync(imagePath)) {
    console.error(`Error: File not found: ${imagePath}`);
    process.exit(1);
  }
  
  if (!config.api_key || !config.secret_key) {
    console.error('Error: Missing API credentials.');
    console.error('Please set BAIDU_OCR_API_KEY and BAIDU_OCR_SECRET_KEY environment variables,');
    console.error('or create a config.json file with api_key and secret_key.');
    process.exit(1);
  }
  
  try {
    console.error('Getting access token...');
    const accessToken = await getAccessToken(config.api_key, config.secret_key);
    
    console.error('Recognizing image...');
    const text = await recognizeImage(imagePath, accessToken);
    
    console.log(text);
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
}

main();
