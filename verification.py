import os
import re
import json
from shutil import copy2
from datetime import datetime

# Répertoires
source_dir = '/var/www/html/code2Gen/builds/'
safe_dir = '/OSOh2GEN/safe'

# Assurez-vous que le répertoire "safe" existe
os.makedirs(safe_dir, exist_ok=True)

# Fonction pour consigner les actions dans un fichier journal
def log_action(action, details):
    log_entry = {
        'action': action,
        'details': details,
        'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    }
    with open('/var/log/html_verification.log', 'a') as log_file:
        log_file.write(json.dumps(log_entry, indent=4) + "\n")

# Fonction pour consigner les raisons des dangers
def log_reason(file, reason, evidence):
    log_entry = {
        'file': file,
        'reason': reason,
        'evidence': evidence,
        'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    }
    with open('/var/log/html_verification.log', 'a') as log_file:
        log_file.write(json.dumps(log_entry, indent=4) + "\n")

# Vérifie si le contenu HTML est sûr ou non
def is_html_safe(html, file):
    malicious_patterns = [
        r'(?<!<!--)\bon\w+="[^"]*"',         # Gestionnaires d'événements inline
        r'\bjavascript:',                    # URIs JavaScript
        r'<iframe\b[^>]*>',                  # Balises <iframe>
        r'<object\b[^>]*>',                  # Balises <object>
        r'<embed\b[^>]*>',                   # Balises <embed>
        r'<form\b[^>]*action=["\']javascript:', # JavaScript dans les formulaires
        r'<script\b[^>]*src=["\'].*?["\']>', # Script externe
        r'<img\b[^>]*src=["\']javascript:'   # Images en JavaScript
    ]

    # Vérification des balises <script>
    for script_content in re.findall(r'<script\b[^>]*>(.*?)<\/script>', html, re.DOTALL | re.IGNORECASE):
        if re.search(r'\b(eval|Function|document\.write|innerHTML)\b', script_content, re.IGNORECASE):
            log_reason(file, "Dangerous script function found", script_content)
            return False

    # Vérification des autres motifs dangereux
    for pattern in malicious_patterns:
        match = re.search(pattern, html, re.IGNORECASE)
        if match:
            log_reason(file, "Dangerous pattern detected", match.group(0))
            return False

    return True

# Nettoie le contenu HTML des éléments dangereux
def clean_html(html):
    html = re.sub(r'<script\b[^>]*>.*?<\/script>', '', html, flags=re.DOTALL | re.IGNORECASE)
    html = re.sub(r'<iframe\b[^>]*>', '', html, flags=re.IGNORECASE)
    html = re.sub(r'<object\b[^>]*>', '', html, flags=re.IGNORECASE)
    html = re.sub(r'<embed\b[^>]*>', '', html, flags=re.IGNORECASE)
    return html

# Traitement des fichiers HTML
html_files = [os.path.join(source_dir, f) for f in os.listdir(source_dir) if f.endswith('.html')]

for file in html_files:
    try:
        with open(file, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        log_action("Failed to open file", {'file': file, 'error': str(e)})
        continue

    # Nettoyer et vérifier le fichier HTML
    clean_content = clean_html(content)

    # Vérifiez si le fichier HTML est sûr
    if not is_html_safe(clean_content, file):
        log_action("Deleted dangerous file", {'file': file})
        os.remove(file)  # Supprimer le fichier malveillant
        continue

    # Copier les fichiers sûrs dans le dossier "safe"
    safe_path = os.path.join(safe_dir, os.path.basename(file))
    copy2(file, safe_path)
    log_action("Copied to safe", {'file': file})
