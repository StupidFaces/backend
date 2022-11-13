-- CreateTable
CREATE TABLE "asset" (
    "uid" SERIAL NOT NULL,
    "asset_id" INTEGER NOT NULL,
    "discord_hodler_id" INTEGER,
    "collection_id" INTEGER NOT NULL,
    "custom_name" VARCHAR,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
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
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "face_of_the_month_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "discord_hodler" (
    "uid" SERIAL NOT NULL,
    "discord_id" VARCHAR NOT NULL,
    "discord_name" VARCHAR NOT NULL,
    "public_key" VARCHAR NOT NULL,
    "hodler_uid" INTEGER,
    "location" VARCHAR,
    "last_gm" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "discord_hodler_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "hodler" (
    "uid" SERIAL NOT NULL,
    "public_key" VARCHAR NOT NULL,

    CONSTRAINT "hodler_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "stupid_face" (
    "uid" SERIAL NOT NULL,
    "number" INTEGER NOT NULL,
    "asset_id" INTEGER NOT NULL,
    "asset_name" VARCHAR NOT NULL,
    "unit_name" VARCHAR NOT NULL,
    "image_url" VARCHAR NOT NULL,
    "blockday" TIMESTAMP(3) NOT NULL,
    "ipfs_hash" TEXT,
    "adoption_name" TEXT,
    "hodler_public_key" TEXT,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "stupid_face_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "stupid_quote" (
    "uid" SERIAL NOT NULL,
    "text" VARCHAR NOT NULL,
    "stupid_face_asset_id" INTEGER NOT NULL,
    "hodler_uid" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "stupid_quote_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "stupid_story" (
    "uid" SERIAL NOT NULL,
    "text" TEXT NOT NULL,
    "stupid_face_asset_id" INTEGER NOT NULL,
    "hodler_uid" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "stupid_story_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "random_attributes" (
    "uid" SERIAL NOT NULL,
    "stupid_face_asset_id" INTEGER NOT NULL,
    "stupidity_level" TEXT NOT NULL,
    "character" TEXT NOT NULL,
    "quirk" TEXT NOT NULL,
    "favourite_movie" TEXT NOT NULL,
    "place_to_sleep" TEXT NOT NULL,
    "related_face_asset_id" INTEGER NOT NULL,
    "relation" TEXT NOT NULL,

    CONSTRAINT "random_attributes_pkey" PRIMARY KEY ("uid")
);

-- CreateIndex
CREATE UNIQUE INDEX "hodler_asset_id_key" ON "asset"("asset_id");

-- CreateIndex
CREATE UNIQUE INDEX "discord_hodler_discord_id_key" ON "discord_hodler"("discord_id");

-- CreateIndex
CREATE UNIQUE INDEX "discord_hodler_public_key_key" ON "discord_hodler"("public_key");

-- CreateIndex
CREATE UNIQUE INDEX "discord_hodler_hodler_uid_key" ON "discord_hodler"("hodler_uid");

-- CreateIndex
CREATE UNIQUE INDEX "hodler_public_key_key" ON "hodler"("public_key");

-- CreateIndex
CREATE UNIQUE INDEX "stupid_face_number_key" ON "stupid_face"("number");

-- CreateIndex
CREATE UNIQUE INDEX "stupid_face_asset_id_key" ON "stupid_face"("asset_id");

-- CreateIndex
CREATE UNIQUE INDEX "stupid_quote_stupid_face_asset_id_key" ON "stupid_quote"("stupid_face_asset_id");

-- CreateIndex
CREATE UNIQUE INDEX "stupid_story_stupid_face_asset_id_key" ON "stupid_story"("stupid_face_asset_id");

-- CreateIndex
CREATE UNIQUE INDEX "random_attributes_stupid_face_asset_id_key" ON "random_attributes"("stupid_face_asset_id");

-- CreateIndex
CREATE UNIQUE INDEX "random_attributes_related_face_asset_id_key" ON "random_attributes"("related_face_asset_id");

-- AddForeignKey
ALTER TABLE "asset" ADD CONSTRAINT "fk_collection" FOREIGN KEY ("collection_id") REFERENCES "collection"("uid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "asset" ADD CONSTRAINT "fk_hodler" FOREIGN KEY ("discord_hodler_id") REFERENCES "discord_hodler"("uid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "face_of_the_month" ADD CONSTRAINT "face_of_the_month_asset_id_fkey" FOREIGN KEY ("asset_id") REFERENCES "stupid_face"("asset_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discord_hodler" ADD CONSTRAINT "discord_hodler_hodler_uid_fkey" FOREIGN KEY ("hodler_uid") REFERENCES "hodler"("uid") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stupid_face" ADD CONSTRAINT "stupid_face_hodler_public_key_fkey" FOREIGN KEY ("hodler_public_key") REFERENCES "hodler"("public_key") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stupid_quote" ADD CONSTRAINT "stupid_quote_stupid_face_asset_id_fkey" FOREIGN KEY ("stupid_face_asset_id") REFERENCES "stupid_face"("asset_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stupid_quote" ADD CONSTRAINT "stupid_quote_hodler_uid_fkey" FOREIGN KEY ("hodler_uid") REFERENCES "hodler"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stupid_story" ADD CONSTRAINT "stupid_story_stupid_face_asset_id_fkey" FOREIGN KEY ("stupid_face_asset_id") REFERENCES "stupid_face"("asset_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stupid_story" ADD CONSTRAINT "stupid_story_hodler_uid_fkey" FOREIGN KEY ("hodler_uid") REFERENCES "hodler"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "random_attributes" ADD CONSTRAINT "random_attributes_stupid_face_asset_id_fkey" FOREIGN KEY ("stupid_face_asset_id") REFERENCES "stupid_face"("asset_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "random_attributes" ADD CONSTRAINT "random_attributes_related_face_asset_id_fkey" FOREIGN KEY ("related_face_asset_id") REFERENCES "stupid_face"("asset_id") ON DELETE RESTRICT ON UPDATE CASCADE;
