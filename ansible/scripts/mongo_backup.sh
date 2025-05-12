#!/bin/bash

# === Config ===
CONFIG_FILE="/etc/mongodump/mongodump.conf"
BACKUP_DIR="/tmp/mongo_backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_FILE="/tmp/mongo_backup_$TIMESTAMP.gz"
S3_BUCKET="s3://mongodb-backup-bucket-61e1028f/mongodb-backups"
LOG_FILE="/var/log/mongo_backup.log"

# === Start Logging ===
echo "[$(date)] Starting MongoDB backup..." >> "$LOG_FILE"

# === Cleanup old dump ===
rm -rf "$BACKUP_DIR"

# === Run mongodump ===
mongodump --config "$CONFIG_FILE" --archive="$ARCHIVE_FILE" --gzip
STATUS=$?

if [ $STATUS -ne 0 ]; then
    echo "[$(date)] mongodump failed with status $STATUS" >> "$LOG_FILE"
    exit 1
else
    echo "[$(date)] mongodump completed successfully: $ARCHIVE_FILE" >> "$LOG_FILE"
fi

# === Upload to S3 ===
aws s3 cp "$ARCHIVE_FILE" "$S3_BUCKET/" >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    echo "[$(date)] Uploaded backup to S3: $S3_BUCKET/$(basename "$ARCHIVE_FILE")" >> "$LOG_FILE"
    rm -f "$ARCHIVE_FILE"  # cleanup
else
    echo "[$(date)] Failed to upload backup to S3" >> "$LOG_FILE"
fi

echo "[$(date)] MongoDB backup script finished." >> "$LOG_FILE"