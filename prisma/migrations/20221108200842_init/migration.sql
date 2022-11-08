-- CreateTable
CREATE TABLE "asset" (
    "uid" SERIAL NOT NULL,
    "asset_id" INTEGER NOT NULL,
    "discord_hodler_id" INTEGER,
    "collection_id" INTEGER NOT NULL,
    "custom_name" VARCHAR,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "asset_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "collection" (
    "uid" SERIAL NOT NULL,
    "name" VARCHAR NOT NULL,
    "address" VARCHAR NOT NULL,

    CONSTRAINT "collection_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "face_of_the_month" (
    "uid" SERIAL NOT NULL,
    "asset_id" INTEGER NOT NULL,
    "month_year" VARCHAR,
    "hodler_public_key" VARCHAR,
    "reward_amount" INTEGER,
    "reward_asset_id" INTEGER,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "face_of_the_month_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "discord_hodler" (
    "uid" SERIAL NOT NULL,
    "discord_id" VARCHAR NOT NULL,
    "discord_name" VARCHAR NOT NULL,
    "public_key" VARCHAR NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "discord_hodler_pkey" PRIMARY KEY ("uid")
);

-- CreateIndex
CREATE UNIQUE INDEX "hodler_asset_id_key" ON "asset"("asset_id");

-- CreateIndex
CREATE UNIQUE INDEX "discord_hodler_discord_id_key" ON "discord_hodler"("discord_id");

-- CreateIndex
CREATE UNIQUE INDEX "discord_hodler_public_key_key" ON "discord_hodler"("public_key");

-- AddForeignKey
ALTER TABLE "asset" ADD CONSTRAINT "fk_collection" FOREIGN KEY ("collection_id") REFERENCES "collection"("uid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "asset" ADD CONSTRAINT "fk_hodler" FOREIGN KEY ("discord_hodler_id") REFERENCES "discord_hodler"("uid") ON DELETE NO ACTION ON UPDATE NO ACTION;
