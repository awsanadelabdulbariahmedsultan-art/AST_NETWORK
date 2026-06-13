#!/bin/bash
# ==============================================================================
# 🌐 AST NETWORK - Official Validator Node Automatic Installer
# 👑 General Architect: Eng. Awsan Adel Abdulbari Ahmed Sultan
# 🛡️ Registered IP Protection ID: 01010305468 / YEMEN
# ==============================================================================

echo "🌐 Starting AST NETWORK Validator Node setup on remote VPS..."

# أ. تحديث حزم النظام الافتراضي للخادم الخارجي
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y curl git wget build-essential software-properties-common

# ب. تحميل وتثبيت محرك البلوكشين المطور المتوافق مع EVM (Go-Ethereum Engine)
echo "📦 Installing sovereign blockchain execution client..."
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update -y
sudo apt-get install -y ethereum

# ج. إنشاء المجلدات المشفرة للنواة والبيانات الخاصة بالشبكة
mkdir -p ~/.ast_network/node_data

# د. تهيئة كتلة التأسيس وحقن الجينات الرقمية ومعرف الشبكة 9041993
echo "⚙️ Initializing Genesis Block with Chain ID 9041993..."
# بافتراض تواجد ملف genesis.json في نفس مسار النشر
geth --datadir ~/.ast_network/node_data init genesis.json

# هـ. ضبط جدار الحماية الأمني لقفل السيرفر وحظر المنافذ الخارجية (Security Firewall)
echo "🛡️ Locking firewall ports for absolute infrastructure protection..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 30303/tcp # منفذ التحقق والربط بين العقد (P2P)
sudo ufw allow 8545/tcp  # منفذ الـ Secured RPC الخاص بمقاصة البنوك والمصانع
sudo ufw allow ssh       # منفذ التحكم السري الخاص بالمهندس أوسان
sudo ufw --force enable

echo "----------------------------------------------------------------------"
echo "✅ AST NETWORK Node Installer configured successfully for execution!"
echo "----------------------------------------------------------------------"
