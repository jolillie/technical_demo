#!/bin/bash

# === Configuration ===
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/var/backups/mongodb"
BACKUP_NAME="mongo_backup_$TIMESTAMP"
ARCHIVE_PATH="$BACKUP_DIR/$BACKUP_NAME.gz"
S3_BUCKET="s3://your-s3-bucket-name/mongo_backups"
LOG_FILE="/var/log/mongo_backup.log"

# === Logging ===
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") $1" | tee -a "$LOG_FILE"
}

# === Start Script ===
log "Starting MongoDB backup"

mkdir -p "$BACKUP_DIR"
log "Created/Verified backup directory: $BACKUP_DIR"

mongodump --archive="$ARCHIVE_PATH" --gzip
if [ $? -ne 0 ]; then
    log "ERROR: mongodump failed"
    exit 1
fi
log "MongoDB dump created at $ARCHIVE_PATH"

aws s3 cp "$ARCHIVE_PATH" "$S3_BUCKET/"
if [ $? -ne 0 ]; then
    log "ERROR: Upload to S3 failed"
    exit 1
fi
log "Backup uploaded to $S3_BUCKET"

# Optional: Cleanup old backups (e.g., older than 7 days)
find "$BACKUP_DIR" -type f -name "*.gz" -mtime +7 -exec rm {} \;
log "Old backups cleaned"

log "MongoDB backup script completed"