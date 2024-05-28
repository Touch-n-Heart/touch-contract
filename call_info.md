##### packageID:

0x7ccca2aae2ac9c756a3118fb6d1e7bd09d0f6bea278702396ef0992a3ca23383

##### Touch OBJs:

TouchSupply objID:

0x771be94f6677433099258760c1c82d876cde4d068f01ecd66cf9d3a264584233

TopN objID:

0xeb91ce53ca3e8e035f93181b88c51765c449584af5a0fa3cab36f33a6998ee82

Airdrop objID:

0x02972551fd7704a37d035b6da0f2de47aa8723bdbe5ccc3f18468786eabead72

AdminCap objID:

0x370ff1999236ab14486481041e893ab3594f785bb7b3015f4d891904870125c8

##### Touch Level(NFT) OBJs:

TouchEligible objID:

0x02d00f8d151aaa20ebe540ab7a0a5b6ba7fc7422c96c41af60f90a852918a20b

TouchNeedForOneLevel objID:

0x6ffb6f4b5444faf1a00834d8046764c682cfc30ea3f5359e3ea5274ef9f3160f

AdminCap ojbID:

0x370ff1999236ab14486481041e893ab3594f785bb7b3015f4d891904870125c8

AllTouchInfos objID:

0x4ba16cfae2aa9a3b3a20df2999bff042b9c1fbd179d9b30ef1cd8481384f0397

##### accounts: 

0x1551c0853e5b1dcce1e02b59a3b65ce815549b798adebb721e2f1cf0d7427b6d

0xf2b6e76f00a8a1c9de435484254f33585870682fea82aa8727d7ed95268a5232



##### call functions 

Touch: Airdrop Object:

```cmd
# update airdrop
sui client call --gas-budget 100000000 \
--package 0x7ccca2aae2ac9c756a3118fb6d1e7bd09d0f6bea278702396ef0992a3ca23383 \
--module airdrop \
--function update_airdrop \
--args 0x370ff1999236ab14486481041e893ab3594f785bb7b3015f4d891904870125c8 0x02972551fd7704a37d035b6da0f2de47aa8723bdbe5ccc3f18468786eabead72 \
"[0x1551c0853e5b1dcce1e02b59a3b65ce815549b798adebb721e2f1cf0d7427b6d, 0xf2b6e76f00a8a1c9de435484254f33585870682fea82aa8727d7ed95268a5232]" \
"[20000000000, 26000000000]"
```

```cmd
# claim airdrop and remove current sender
sui client call --gas-budget 100000000 \
--package 0x7ccca2aae2ac9c756a3118fb6d1e7bd09d0f6bea278702396ef0992a3ca23383 \
--module touch \
--function claim_airdrop \
--args 0x02972551fd7704a37d035b6da0f2de47aa8723bdbe5ccc3f18468786eabead72 0x771be94f6677433099258760c1c82d876cde4d068f01ecd66cf9d3a264584233 
```

Touch: TopN Object:

```cmd
# update TopN
# call twice test accumulating awards
sui client call --gas-budget 100000000 \
--package 0x7ccca2aae2ac9c756a3118fb6d1e7bd09d0f6bea278702396ef0992a3ca23383 \
--module top_n \
--function update_topn \
--args 0x370ff1999236ab14486481041e893ab3594f785bb7b3015f4d891904870125c8 0xeb91ce53ca3e8e035f93181b88c51765c449584af5a0fa3cab36f33a6998ee82 \
"[0x1551c0853e5b1dcce1e02b59a3b65ce815549b798adebb721e2f1cf0d7427b6d, 0xf2b6e76f00a8a1c9de435484254f33585870682fea82aa8727d7ed95268a5232, 0x8a818f623c3b11b953a383151bf57dc1f6b3759066e9754ea47833953df557d1]" \
"[30000000000, 50000000000, 99000000000]"
```

```cmd
# claim award and remove current sender
sui client call --gas-budget 100000000 \
--package 0x7ccca2aae2ac9c756a3118fb6d1e7bd09d0f6bea278702396ef0992a3ca23383 \
--module touch \
--function claim_topn \
--args 0xeb91ce53ca3e8e035f93181b88c51765c449584af5a0fa3cab36f33a6998ee82 0x771be94f6677433099258760c1c82d876cde4d068f01ecd66cf9d3a264584233 
```



Touch Level Object:

```cmd
# update all nft infos
sui client call --gas-budget 100000000 \
--package 0x7ccca2aae2ac9c756a3118fb6d1e7bd09d0f6bea278702396ef0992a3ca23383 \
--module touch_level \
--function update_touch_infos \
--args 0x370ff1999236ab14486481041e893ab3594f785bb7b3015f4d891904870125c8 0x4ba16cfae2aa9a3b3a20df2999bff042b9c1fbd179d9b30ef1cd8481384f0397 \
\["Adventurer","Virtuoso","Virtuoso"\] \[1,1,1\] \["Nobody","Nobody","Daniel\ Craig"\] \
\["https://ipfs.io/ipfs/bafybeiekxx6cmiwkiajqjzu6o26dni4m7cpnjf66pdsuskzbpiaxagebvi/Adventurer-1-Nobody.svg","https://ipfs.io/ipfs/bafybeiekxx6cmiwkiajqjzu6o26dni4m7cpnjf66pdsuskzbpiaxagebvi/Virtuoso-1-Nobody.svg","https://ipfs.io/ipfs/bafybeiekxx6cmiwkiajqjzu6o26dni4m7cpnjf66pdsuskzbpiaxagebvi/Virtuoso-2-Daniel%20Craig.svg"\] \
\["Ad","Bold","Bold"\]
```



```cmd
# update Touch eligible
sui client call --gas-budget 100000000 \
--package 0x7ccca2aae2ac9c756a3118fb6d1e7bd09d0f6bea278702396ef0992a3ca23383 \
--module touch_level \
--function update_addrs \
--args 0x370ff1999236ab14486481041e893ab3594f785bb7b3015f4d891904870125c8 0x02d00f8d151aaa20ebe540ab7a0a5b6ba7fc7422c96c41af60f90a852918a20b \
"[0x1551c0853e5b1dcce1e02b59a3b65ce815549b798adebb721e2f1cf0d7427b6d, 0xf2b6e76f00a8a1c9de435484254f33585870682fea82aa8727d7ed95268a5232, 0x8a818f623c3b11b953a383151bf57dc1f6b3759066e9754ea47833953df557d1]" \
"[2, 2, 2]"
```

```cmd
# claim, clear TouchEligible and get TouchProfile NFT
# call by eligible addresses
# level 1: Nobody, level 2: Daniel Craig
sui client call --gas-budget 100000000 \
--package 0x7ccca2aae2ac9c756a3118fb6d1e7bd09d0f6bea278702396ef0992a3ca23383 \
--module touch_level \
--function claim \
--args 0x02d00f8d151aaa20ebe540ab7a0a5b6ba7fc7422c96c41af60f90a852918a20b "Daniel Craig" "Virtuoso" \
"Bold and practical experimenters, masters of all kinds of tools." 
```

```cmd
# Upgrade NFT
sui client call --gas-budget 100000000 \
--package 0x7ccca2aae2ac9c756a3118fb6d1e7bd09d0f6bea278702396ef0992a3ca23383 \
--module touch_level \
--function upgrade \
--args TouchNFT-obj-ID \
0x6ffb6f4b5444faf1a00834d8046764c682cfc30ea3f5359e3ea5274ef9f3160f \
0x771be94f6677433099258760c1c82d876cde4d068f01ecd66cf9d3a264584233 \
TouchCoin-obj-ID \
"Michael Jordan" "3"
```

```cmd
# Set a new TouchNeedForOneLevel and upgrade another NFT
# Set new value
sui client call --gas-budget 100000000 \
--package 0x7ccca2aae2ac9c756a3118fb6d1e7bd09d0f6bea278702396ef0992a3ca23383 \
--module touch_level \
--function set_touch_need_value \
--args 0x370ff1999236ab14486481041e893ab3594f785bb7b3015f4d891904870125c8 \
0x6ffb6f4b5444faf1a00834d8046764c682cfc30ea3f5359e3ea5274ef9f3160f "20000000000"
```











