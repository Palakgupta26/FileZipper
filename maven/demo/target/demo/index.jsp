<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zippify - File Compressor</title>
    <style>
        /* Reset some default styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-color: #121212;
            background-image: linear-gradient(135deg, rgba(18, 18, 18, 0.8), rgba(0, 0, 0, 0.9));
            position: relative;
            overflow: hidden;
        }

        .container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0px 10px 30px rgba(0, 0, 0, 0.5);
            text-align: center;
            max-width: 600px;
            width: 100%;
        }

        h1 {
            color: #ffffff;
            margin-bottom: 20px;
            font-size: 36px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
        }

        .logo {
            width: 150px;
            margin-bottom: 20px;
        }

        .file-input {
            position: relative;
            margin-bottom: 20px;
        }

        .file-input input[type="file"] {
            opacity: 0;
            position: absolute;
            width: 100%;
            height: 50px;
            top: 0;
            left: 0;
            cursor: pointer;
        }

        .file-input label {
            display: block;
            background-color: #4a4a4a;
            color: #ffffff;
            border: none;
            padding: 15px;
            text-align: center;
            border-radius: 10px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.3s;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.5);
        }

        .file-input label:hover {
            background-color: #5c5c5c;
            transform: translateY(-2px);
        }

        .buttons {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            margin: 20px 0;
        }

        button {
            padding: 14px 24px;
            background-color: #ff5a5a;
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 16px;
            margin: 5px;
            flex: 1 1 45%;
            transition: all 0.3s;
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.5);
        }

        button:hover {
            background-color: #ff3d3d;
            transform: translateY(-3px);
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.5);
        }

        button i {
            margin-right: 8px;
        }

        #download-link {
            display: none;
            margin-top: 20px;
            text-decoration: none;
            background-color: #28a745;
            color: white;
            padding: 12px 20px;
            border-radius: 10px;
            transition: background-color 0.3s, transform 0.3s;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.3);
        }

        #download-link:hover {
            background-color: #218838;
            transform: translateY(-2px);
            box-shadow: 0px 6px 15px rgba(0, 0, 0, 0.5);
        }

        .loading {
            display: none;
            margin-top: 15px;
            font-size: 14px;
            color: #007bff;
        }

        @media (max-width: 480px) {
            button {
                flex: 1 1 100%;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <img src="logo.png" alt="Zippify Logo" class="logo"> <!-- Placeholder for logo -->
        <h1>Zippify</h1>

        <!-- File Upload Input -->
        <div class="file-input">
            <label for="fileInput">
                <i class="fas fa-upload"></i> Choose File
            </label>
            <input type="file" id="fileInput" required>
        </div>

        <!-- Compression Options Buttons -->
        <div class="buttons">
            <button id="compressImageBtn">
                <i class="fas fa-image"></i> Compress Image
            </button>
            <button id="compressPdfBtn">
                <i class="fas fa-file-pdf"></i> Compress PDF
            </button>
            <button id="compressVideoBtn">
                <i class="fas fa-video"></i> Compress Video
            </button>
            <button id="zipFileBtn">
                <i class="fas fa-file-archive"></i> Zip Files
            </button>
        </div>

        <!-- Download Link -->
        <a id="download-link" href="#">Download Compressed File</a>
        <p class="loading" id="loading">Compressing... Please wait.</p>
    </div>

    <!-- Font Awesome for icons -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

    <script>
        const fileInput = document.getElementById('fileInput');
        const downloadLink = document.getElementById('download-link');
        const loading = document.getElementById('loading');

        document.getElementById('compressImageBtn').addEventListener('click', function() {
            handleFileCompression('compressImage');
        });

        document.getElementById('compressPdfBtn').addEventListener('click', function() {
            handleFileCompression('compressPdf');
        });

        document.getElementById('compressVideoBtn').addEventListener('click', function() {
            handleFileCompression('compressVideo');
        });

        document.getElementById('zipFileBtn').addEventListener('click', function() {
            handleFileCompression('zipFiles');
        });

        function handleFileCompression(action) {
            const file = fileInput.files[0];
            if (!file) {
                alert('Please select a file.');
                return;
            }

            loading.style.display = 'block';
            downloadLink.style.display = 'none';

            const formData = new FormData();
            formData.append('file', file);
            formData.append('action', action);

            fetch('/compress', {
                method: 'POST',
                body: formData
            })
            .then(response => response.blob())
            .then(blob => {
                const url = window.URL.createObjectURL(blob);
                downloadLink.href = url;
                downloadLink.download = file.name.split('.')[0] + '_compressed.' + file.name.split('.').pop();
                downloadLink.style.display = 'block';
                loading.style.display = 'none';
            })
            .catch(error => {
                console.error('Error:', error);
                loading.style.display = 'none';
            });
        }
    </script>

</body>
</html>
