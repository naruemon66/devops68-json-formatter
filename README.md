# =========================
# STEP 1: Clone Project (บนเครื่องเรา)
# =========================
git clone https://github.com/naruemon66/devops68-json-formatter.git
cd devops68-json-formatter

# =========================
# STEP 2: สร้าง Infrastructure (Terraform)
# =========================
cd terraform
terraform init
terraform apply -auto-approve

# ===== สำคัญ =====
# หลังจาก run เสร็จ ให้ดู output แล้ว "คัดลอก PUBLIC_IP"
# =================

# =========================
# STEP 3: Connect เข้า EC2
# =========================
# (ใช้ PowerShell / Terminal เครื่องเรา)
ssh -i "my-terraform-key.pem" ubuntu@<PUBLIC_IP>

# =========================
# STEP 4: เตรียมเครื่อง EC2
# =========================
sudo apt update -y

# ติดตั้ง Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# เช็คเวอร์ชัน (ควรขึ้น v20+)
node -v
npm -v

# =========================
# STEP 5: Deploy Project ลง EC2
# =========================
git clone https://github.com/naruemon66/devops68-json-formatter.git
cd devops68-json-formatter

# ติดตั้ง dependencies
npm install

# =========================
# STEP 6: Run Application
# =========================
node index.js

# ===== ถ้าขึ้นแบบนี้ = สำเร็จ =====
# JSON Formatter API on port 3026

# =========================
# STEP 7: เปิด Browser ทดสอบ
# =========================
# เอา PUBLIC_IP ไปเปิดใน browser:

http://<PUBLIC_IP>:3026/format?json=%7B%22a%22%3A1%7D

# =========================
# STEP 8: (สำคัญ) รันแบบ Background กันดับ
# =========================
# กด Ctrl + C ก่อน แล้วพิมพ์:
nohup node index.js > app.log 2>&1 &

# =========================
# STEP 9: (ถ้าจะหยุด)
# =========================
pkill node
