#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY

set -e

if [ "${WRT_TARGET}" != "qualcommax" ]; then
    echo "跳过 QCA 6.18 内核补丁"
    exit 0
fi

PATCH_DIR="$GITHUB_WORKSPACE/wrt/target/linux/qualcommax/patches-6.18"
PATCH_FILE="$PATCH_DIR/9990-qualcommax-fix-tx-cacheline-overflow.patch"

mkdir -p "$PATCH_DIR"

cat > "$PATCH_FILE" <<'EOF'
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -13111,7 +13111,7 @@ static void __init net_dev_struct_check(
 #ifdef CONFIG_NET_XGRESS
 	CACHELINE_ASSERT_GROUP_MEMBER(struct net_device, net_device_read_tx, tcx_egress);
 #endif
-	CACHELINE_ASSERT_GROUP_SIZE(struct net_device, net_device_read_tx, 160);
+	CACHELINE_ASSERT_GROUP_SIZE(struct net_device, net_device_read_tx, 168);
 
 	/* TXRX read-mostly hotpath */
EOF

echo "QCA 6.18 内核补丁已应用：160 -> 168"
