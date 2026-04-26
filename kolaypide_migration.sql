-- ============================================================
-- KolayPide — Tam Veritabanı Şeması
-- Supabase SQL Editor'da çalıştır
-- ============================================================

-- 1. TABLOLAR
-- ============================================================

CREATE TABLE IF NOT EXISTS kafeler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid,
  kafe_adi text DEFAULT 'Kafem',
  plan text DEFAULT 'ucretsiz',
  garsonlar jsonb DEFAULT '["Ali", "Ayşe"]',
  urunler jsonb DEFAULT '{}',
  masalar jsonb DEFAULT '[]',
  created_at timestamptz DEFAULT now(),
  kafe_kodu text,
  telefon text DEFAULT '',
  adres text DEFAULT '',
  aktif_masalar jsonb DEFAULT '[]',
  garson_kodu text,
  vergi_no text,
  fatura_adres text,
  fatura_il text,
  fatura_ilce text,
  email text,
  receteler jsonb DEFAULT '{}',
  plan_bitis timestamptz,
  kupon_kodu text,
  kupon_indirim numeric,
  son_giris timestamptz,
  crm_notlar jsonb DEFAULT '[]',
  toplam_ciro numeric DEFAULT 0,
  banner_mesaj text,
  ana_renk text DEFAULT '#e03a1e',
  logo_url text,
  banner_url text,
  ai_paket boolean DEFAULT false,
  referans_kodu text,
  getiren_referans text,
  promosyon_bitis timestamptz,
  urun_varyantlari jsonb DEFAULT '[]',
  grup_listesi jsonb DEFAULT '["Salon", "Bahçe", "Teras", "VIP"]',
  app_tema text DEFAULT 'pide',
  app_vurgu text DEFAULT '#e03a1e',
  kat_sirasi text[],
  hizmet_aktif boolean DEFAULT true,
  manuel_pasif boolean DEFAULT false,
  odeme_conversation_id text,
  odeme_bekliyor boolean DEFAULT false,
  odeme_plan text,
  odeme_donem text DEFAULT 'aylik',
  son_odeme timestamptz,
  son_odeme_tutar numeric,
  plan_donem text DEFAULT 'aylik',
  odeme_tipleri jsonb DEFAULT '[]',
  odeme_bekliyor_zaman timestamptz,
  ai_analiz_limit integer,
  ai_sohbet_limit integer,
  gecici_sifre text,
  son_cikis timestamptz
);

CREATE TABLE IF NOT EXISTS kolaycafenlar (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  masa_no integer,
  masa_ad text,
  toplam numeric DEFAULT 0,
  indirim numeric DEFAULT 0,
  garson text DEFAULT '',
  siparisler jsonb DEFAULT '[]',
  odeme_tipi text DEFAULT 'nakit',
  musteri_adi text,
  cari_tutar numeric,
  created_at timestamptz DEFAULT now(),
  kapanma_zamani timestamptz DEFAULT now(),
  masa_notu text,
  vardiya_id uuid,
  odeme_detay jsonb
);

CREATE TABLE IF NOT EXISTS ai_kayitlar (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  kafe_adi text,
  plan text,
  tip text NOT NULL,
  donem text,
  icerik jsonb NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ai_kullanim (
  id bigserial PRIMARY KEY,
  kafe_id uuid,
  tip text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS vardiyalar (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  baslangic timestamptz NOT NULL DEFAULT now(),
  bitis timestamptz,
  toplam_ciro numeric DEFAULT 0,
  aciklama text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS musteriler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  isim text NOT NULL,
  telefon text NOT NULL,
  adres text,
  notlar text,
  son_siparis jsonb,
  son_siparis_tarih timestamptz,
  siparis_sayisi integer DEFAULT 0,
  toplam_harcama numeric DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS kuponlar (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kod text NOT NULL,
  indirim_orani integer NOT NULL,
  bitis_tarihi timestamptz NOT NULL,
  aktif boolean DEFAULT true,
  kullanim_sayisi integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS yorumlar (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  isim text NOT NULL,
  kafe_adi text,
  yildiz integer NOT NULL,
  yorum text NOT NULL,
  onaylandi boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS skt_urunler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid NOT NULL,
  urun_adi text NOT NULL,
  kategori text,
  miktar numeric,
  birim text DEFAULT 'adet',
  skt_tarihi date NOT NULL,
  notlar text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS varsayilan_urunler (
  id serial PRIMARY KEY,
  urunler jsonb NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS toptancilar (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  isim text NOT NULL,
  yetkili text,
  telefon text,
  kart_limit numeric DEFAULT 0,
  notlar text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS toptanci_hareketler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  toptanci_id uuid,
  kafe_id uuid,
  tip text NOT NULL,
  odeme_tip text,
  tutar numeric NOT NULL,
  aciklama text,
  tarih timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS kasa_hareketler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  tip text NOT NULL,
  odeme_tip text DEFAULT 'nakit',
  tutar numeric NOT NULL,
  aciklama text,
  tarih timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS kredi_kartlar (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  banka text NOT NULL,
  son_4_hane text,
  limit_tutar numeric DEFAULT 0,
  kesim_gunu integer,
  odeme_gunu integer,
  renk text DEFAULT '#3b82f6',
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS kredi_kart_harcamalar (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kart_id uuid,
  kafe_id uuid,
  aciklama text,
  tutar numeric NOT NULL,
  tarih timestamptz DEFAULT now(),
  gelir_gider_id uuid
);

CREATE TABLE IF NOT EXISTS kredi_kart_odemeler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kart_id uuid,
  kafe_id uuid,
  tutar numeric NOT NULL,
  odeme_tip text DEFAULT 'nakit',
  donem_baslangic timestamptz,
  donem_bitis timestamptz,
  tarih timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS gelir_gider (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  tip text NOT NULL,
  kategori text NOT NULL,
  aciklama text,
  tutar numeric NOT NULL,
  tarih timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  odeme_tip text DEFAULT 'nakit',
  vade_tarihi timestamptz,
  odendi boolean DEFAULT true
);

CREATE TABLE IF NOT EXISTS iyzico_islemler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id text NOT NULL,
  kafe_id uuid,
  plan text,
  donem text,
  tutar numeric,
  durum text DEFAULT 'bekliyor',
  odeme_id text,
  kart_token text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS odemeler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  plan text NOT NULL,
  donem text NOT NULL DEFAULT 'aylik',
  tutar numeric NOT NULL,
  yontem text DEFAULT 'iyzico',
  durum text DEFAULT 'bekliyor',
  iyzico_ref text,
  aciklama text,
  plan_bitis_oncesi timestamptz,
  plan_bitis_sonrasi timestamptz,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS hata_loglari (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  mesaj text,
  kaynak text,
  satir integer,
  sutun integer,
  browser text,
  url text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS cari_musteriler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  ad text NOT NULL,
  telefon text,
  notlar text,
  bakiye numeric DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS cari_islemler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  musteri_id uuid,
  tip text NOT NULL,
  tutar numeric NOT NULL,
  odeme_tipi text,
  aciklama text,
  siparisler jsonb,
  garson text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS online_siparisler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  masa_no integer,
  siparisler jsonb DEFAULT '[]',
  durum text DEFAULT 'bekliyor',
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS stok_hareketler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kafe_id uuid,
  urun_adi text,
  miktar numeric,
  tip text,
  aciklama text,
  created_at timestamptz DEFAULT now()
);

-- 2. RLS AKTİF ET
-- ============================================================
ALTER TABLE kafeler ENABLE ROW LEVEL SECURITY;
ALTER TABLE kolaycafenlar ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_kayitlar ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_kullanim ENABLE ROW LEVEL SECURITY;
ALTER TABLE vardiyalar ENABLE ROW LEVEL SECURITY;
ALTER TABLE musteriler ENABLE ROW LEVEL SECURITY;
ALTER TABLE kuponlar ENABLE ROW LEVEL SECURITY;
ALTER TABLE yorumlar ENABLE ROW LEVEL SECURITY;
ALTER TABLE skt_urunler ENABLE ROW LEVEL SECURITY;
ALTER TABLE varsayilan_urunler ENABLE ROW LEVEL SECURITY;
ALTER TABLE toptancilar ENABLE ROW LEVEL SECURITY;
ALTER TABLE toptanci_hareketler ENABLE ROW LEVEL SECURITY;
ALTER TABLE kasa_hareketler ENABLE ROW LEVEL SECURITY;
ALTER TABLE kredi_kartlar ENABLE ROW LEVEL SECURITY;
ALTER TABLE kredi_kart_harcamalar ENABLE ROW LEVEL SECURITY;
ALTER TABLE kredi_kart_odemeler ENABLE ROW LEVEL SECURITY;
ALTER TABLE gelir_gider ENABLE ROW LEVEL SECURITY;
ALTER TABLE iyzico_islemler ENABLE ROW LEVEL SECURITY;
ALTER TABLE odemeler ENABLE ROW LEVEL SECURITY;
ALTER TABLE hata_loglari ENABLE ROW LEVEL SECURITY;
ALTER TABLE cari_musteriler ENABLE ROW LEVEL SECURITY;
ALTER TABLE cari_islemler ENABLE ROW LEVEL SECURITY;
ALTER TABLE online_siparisler ENABLE ROW LEVEL SECURITY;
ALTER TABLE stok_hareketler ENABLE ROW LEVEL SECURITY;

-- 3. RLS POLİTİKALARI
-- ============================================================

-- kafeler
CREATE POLICY "admin_full_access" ON kafeler FOR ALL USING (true);
CREATE POLICY "kafe_kodu_ile_oku" ON kafeler FOR SELECT USING (true);
CREATE POLICY "kafe_olusturabilir" ON kafeler FOR INSERT WITH CHECK (true);
CREATE POLICY "kendi_kafesini_gorur" ON kafeler FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "kendi_kafesini_gunceller" ON kafeler FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY "kendi_kafesini_siler" ON kafeler FOR DELETE USING (user_id = auth.uid());
CREATE POLICY "admin_panel_update" ON kafeler FOR UPDATE TO anon USING (true);
CREATE POLICY "musteri_qr_siparis_guncelle" ON kafeler FOR UPDATE TO anon USING (true);

-- kolaycafenlar (adisyon kayıtları — aynı tablo adını koruyoruz)
CREATE POLICY "kafe sahipleri okuyabilir" ON kolaycafenlar FOR SELECT USING (true);
CREATE POLICY "kafe sahipleri yazabilir" ON kolaycafenlar FOR INSERT WITH CHECK (true);
CREATE POLICY "kolaycafenlar update" ON kolaycafenlar FOR UPDATE USING (true);
CREATE POLICY "kendi_verisi" ON kolaycafenlar FOR ALL USING (
  (kafe_id IN (SELECT id FROM kafeler WHERE user_id = auth.uid()))
  OR (kafe_id IN (SELECT id FROM kafeler WHERE kafe_kodu = current_setting('app.garson_kafe_kodu', true)))
);

-- ai_kayitlar (RLS disable — admin her şeyi görsün)
ALTER TABLE ai_kayitlar DISABLE ROW LEVEL SECURITY;

-- ai_kullanim
CREATE POLICY "kendi_verisi" ON ai_kullanim FOR ALL USING (
  kafe_id IN (SELECT id FROM kafeler WHERE user_id = auth.uid())
);

-- vardiyalar
CREATE POLICY "Kafe kendi vardiyalarını okuyabilir" ON vardiyalar FOR SELECT USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);
CREATE POLICY "Kafe kendi vardiyalarını yazabilir" ON vardiyalar FOR INSERT WITH CHECK (true);
CREATE POLICY "Kafe kendi vardiyalarını güncelleyebilir" ON vardiyalar FOR UPDATE USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);

-- musteriler
CREATE POLICY "musteriler_select" ON musteriler FOR SELECT USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);
CREATE POLICY "musteriler_insert" ON musteriler FOR INSERT WITH CHECK (true);
CREATE POLICY "musteriler_update" ON musteriler FOR UPDATE USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);
CREATE POLICY "musteriler_delete" ON musteriler FOR DELETE USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);

-- kuponlar
CREATE POLICY "kupon_herkes_okur" ON kuponlar FOR SELECT USING (true);
CREATE POLICY "kupon_auth_yazar" ON kuponlar FOR INSERT WITH CHECK (true);
CREATE POLICY "kupon_auth_gunceller" ON kuponlar FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "kupon_auth_siler" ON kuponlar FOR DELETE USING (auth.role() = 'authenticated');

-- yorumlar
CREATE POLICY "yorum_herkes_okur" ON yorumlar FOR SELECT USING (true);
CREATE POLICY "yorum_herkes_ekler" ON yorumlar FOR INSERT WITH CHECK (true);
CREATE POLICY "yorum_auth_gunceller" ON yorumlar FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "yorum_auth_siler" ON yorumlar FOR DELETE USING (auth.role() = 'authenticated');

-- skt_urunler
CREATE POLICY "skt_kendi_kafe" ON skt_urunler FOR ALL USING (
  kafe_id IN (SELECT id FROM kafeler WHERE user_id = auth.uid())
);

-- varsayilan_urunler
CREATE POLICY "herkes_okuyabilir" ON varsayilan_urunler FOR SELECT USING (true);

-- toptancilar
CREATE POLICY "toptancilar_select" ON toptancilar FOR SELECT USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);
CREATE POLICY "toptancilar_insert" ON toptancilar FOR INSERT WITH CHECK (true);
CREATE POLICY "toptancilar_update" ON toptancilar FOR UPDATE USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);
CREATE POLICY "toptancilar_delete" ON toptancilar FOR DELETE USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);

-- toptanci_hareketler
CREATE POLICY "toptanci_hareketler_select" ON toptanci_hareketler FOR SELECT USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);
CREATE POLICY "toptanci_hareketler_insert" ON toptanci_hareketler FOR INSERT WITH CHECK (true);
CREATE POLICY "toptanci_hareketler_delete" ON toptanci_hareketler FOR DELETE USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);

-- kasa_hareketler
CREATE POLICY "kasa_hareketler_select" ON kasa_hareketler FOR SELECT USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);
CREATE POLICY "kasa_hareketler_insert" ON kasa_hareketler FOR INSERT WITH CHECK (true);
CREATE POLICY "kasa_hareketler_delete" ON kasa_hareketler FOR DELETE USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid() LIMIT 1)
);

-- kredi_kartlar
CREATE POLICY "kendi_verisi" ON kredi_kartlar FOR ALL USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid())
);

-- kredi_kart_harcamalar
CREATE POLICY "kendi_verisi" ON kredi_kart_harcamalar FOR ALL USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid())
);

-- kredi_kart_odemeler
CREATE POLICY "kendi_verisi" ON kredi_kart_odemeler FOR ALL USING (
  kafe_id = (SELECT id FROM kafeler WHERE user_id = auth.uid())
);

-- gelir_gider
CREATE POLICY "kendi_verisi" ON gelir_gider FOR ALL USING (
  kafe_id IN (SELECT id FROM kafeler WHERE user_id = auth.uid())
);
CREATE POLICY "okuma" ON gelir_gider FOR SELECT USING (true);
CREATE POLICY "yazma" ON gelir_gider FOR INSERT WITH CHECK (true);
CREATE POLICY "silme" ON gelir_gider FOR DELETE USING (true);

-- iyzico_islemler
CREATE POLICY "servis_erisim" ON iyzico_islemler FOR ALL USING (true);

-- odemeler
CREATE POLICY "Admin okur" ON odemeler FOR ALL USING (true);

-- hata_loglari
CREATE POLICY "Hata yaz" ON hata_loglari FOR INSERT WITH CHECK (true);
CREATE POLICY "Hata oku" ON hata_loglari FOR SELECT USING (true);
CREATE POLICY "kendi_verisi" ON hata_loglari FOR ALL USING (
  kafe_id IN (SELECT id FROM kafeler WHERE user_id = auth.uid())
);

-- cari_musteriler
CREATE POLICY "kafe_erisim_musteriler" ON cari_musteriler FOR ALL USING (true);
CREATE POLICY "kendi_verisi" ON cari_musteriler FOR ALL USING (
  kafe_id IN (SELECT id FROM kafeler WHERE user_id = auth.uid())
);

-- cari_islemler
CREATE POLICY "kafe_erisim_islemler" ON cari_islemler FOR ALL USING (true);
CREATE POLICY "kendi_verisi" ON cari_islemler FOR ALL USING (
  kafe_id IN (SELECT id FROM kafeler WHERE user_id = auth.uid())
);

-- online_siparisler
CREATE POLICY "online_erisim" ON online_siparisler FOR ALL USING (true);
CREATE POLICY "kendi_verisi" ON online_siparisler FOR ALL USING (
  (kafe_id IN (SELECT id FROM kafeler WHERE user_id = auth.uid()))
  OR (kafe_id IN (SELECT id FROM kafeler WHERE kafe_kodu = current_setting('app.garson_kafe_kodu', true)))
);

-- stok_hareketler
CREATE POLICY "stok_erisim" ON stok_hareketler FOR ALL USING (true);
CREATE POLICY "kendi_verisi" ON stok_hareketler FOR ALL USING (
  kafe_id IN (SELECT id FROM kafeler WHERE user_id = auth.uid())
);

-- 4. FONKSİYONLAR
-- ============================================================

CREATE OR REPLACE FUNCTION increment_ciro(kafe_id_param uuid, miktar numeric)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  UPDATE kafeler 
  SET toplam_ciro = COALESCE(toplam_ciro, 0) + miktar
  WHERE id = kafe_id_param;
END;
$$;

CREATE OR REPLACE FUNCTION update_skt_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$;

CREATE TRIGGER skt_updated_at_trigger
  BEFORE UPDATE ON skt_urunler
  FOR EACH ROW EXECUTE FUNCTION update_skt_updated_at();

CREATE OR REPLACE FUNCTION musteri_siparis_ekle(
  p_kafe_id uuid,
  p_masa_id text,
  p_masa_adi text,
  p_siparisler jsonb,
  p_not text DEFAULT ''
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_aktif_masalar JSONB;
  v_masa JSONB;
  v_masa_idx INT;
  v_siparis JSONB;
  v_mevcut_idx INT;
  v_saat TEXT;
  v_bulunan BOOLEAN;
  v_masa_id_normalized TEXT;
  v_item_id TEXT;
BEGIN
  SELECT aktif_masalar INTO v_aktif_masalar
  FROM kafeler WHERE id = p_kafe_id;

  IF v_aktif_masalar IS NULL THEN
    v_aktif_masalar := '[]'::JSONB;
  END IF;

  v_saat := TO_CHAR(NOW() AT TIME ZONE 'Europe/Istanbul', 'HH24:MI');
  v_masa_id_normalized := TRIM(p_masa_id);

  v_masa_idx := -1;
  FOR i IN 0 .. jsonb_array_length(v_aktif_masalar) - 1 LOOP
    v_item_id := TRIM(v_aktif_masalar->i->>'id');
    IF v_item_id = v_masa_id_normalized
       OR (v_item_id ~ '^\d+$' AND v_masa_id_normalized ~ '^\d+$' 
           AND v_item_id::BIGINT = v_masa_id_normalized::BIGINT) THEN
      v_masa_idx := i;
      v_masa := v_aktif_masalar->i;
      EXIT;
    END IF;
  END LOOP;

  IF v_masa_idx = -1 THEN
    DECLARE
      v_masa_id_json JSONB;
    BEGIN
      IF v_masa_id_normalized ~ '^\d+$' THEN
        v_masa_id_json := to_jsonb(v_masa_id_normalized::BIGINT);
      ELSE
        v_masa_id_json := to_jsonb(v_masa_id_normalized);
      END IF;
      v_masa := jsonb_build_object(
        'id', v_masa_id_json,
        'ad', p_masa_adi,
        'siparisler', '[]'::JSONB,
        'not', '',
        'garson', '',
        'indirim', 0
      );
    END;
    v_aktif_masalar := v_aktif_masalar || jsonb_build_array(v_masa);
    v_masa_idx := jsonb_array_length(v_aktif_masalar) - 1;
    v_masa := v_aktif_masalar->v_masa_idx;
  END IF;

  FOR v_siparis IN SELECT * FROM jsonb_array_elements(p_siparisler) LOOP
    v_bulunan := FALSE;
    v_mevcut_idx := -1;

    IF jsonb_array_length(COALESCE(v_masa->'siparisler', '[]'::JSONB)) > 0 THEN
      FOR j IN 0 .. jsonb_array_length(v_masa->'siparisler') - 1 LOOP
        IF (v_masa->'siparisler'->j->>'isim') = (v_siparis->>'isim')
           AND (v_masa->'siparisler'->j->>'musteri')::BOOLEAN = TRUE THEN
          v_mevcut_idx := j;
          v_bulunan := TRUE;
          EXIT;
        END IF;
      END LOOP;
    END IF;

    IF v_bulunan THEN
      v_masa := jsonb_set(
        v_masa,
        ARRAY['siparisler', v_mevcut_idx::TEXT, 'adet'],
        to_jsonb((v_masa->'siparisler'->v_mevcut_idx->>'adet')::INT + (v_siparis->>'adet')::INT)
      );
    ELSE
      v_masa := jsonb_set(
        v_masa,
        ARRAY['siparisler'],
        COALESCE(v_masa->'siparisler', '[]'::JSONB) || jsonb_build_array(
          v_siparis || jsonb_build_object(
            'ilkSaat', v_saat,
            'musteri', TRUE,
            'mutfak_teslim', FALSE
          )
        )
      );
    END IF;
  END LOOP;

  IF p_not != '' THEN
    v_masa := jsonb_set(
      v_masa,
      ARRAY['not'],
      to_jsonb(COALESCE(NULLIF(v_masa->>'not',''), '') || 
        CASE WHEN COALESCE(v_masa->>'not','') != '' THEN ' | ' ELSE '' END || 
        '🧾 ' || p_not)
    );
  END IF;

  v_masa := v_masa
    || jsonb_build_object('mutfak_durum', 'bekliyor')
    || jsonb_build_object('mutfak_zaman', NOW()::TEXT);

  v_aktif_masalar := jsonb_set(v_aktif_masalar, ARRAY[v_masa_idx::TEXT], v_masa);
  UPDATE kafeler SET aktif_masalar = v_aktif_masalar WHERE id = p_kafe_id;

  RETURN jsonb_build_object('ok', TRUE, 'masa_id', p_masa_id);
END;
$$;

-- musteri_siparis_ekle fonksiyonuna anon erişim ver
GRANT EXECUTE ON FUNCTION musteri_siparis_ekle(uuid, text, text, jsonb, text) TO anon;

-- 5. VARSAYILAN PİDE MENÜSÜ
-- ============================================================
INSERT INTO varsayilan_urunler (urunler) VALUES (
  '[
    {"isim":"Karışık Pide","fiyat":180,"ikon":"🥙","kategori":"Pide"},
    {"isim":"Kıymalı Pide","fiyat":160,"ikon":"🥙","kategori":"Pide"},
    {"isim":"Kaşarlı Pide","fiyat":150,"ikon":"🧀","kategori":"Pide"},
    {"isim":"Kuşbaşılı Pide","fiyat":190,"ikon":"🥙","kategori":"Pide"},
    {"isim":"Ispanaklı Pide","fiyat":145,"ikon":"🥙","kategori":"Pide"},
    {"isim":"Sucuklu Pide","fiyat":155,"ikon":"🥙","kategori":"Pide"},
    {"isim":"Lahmacun","fiyat":80,"ikon":"🫓","kategori":"Lahmacun"},
    {"isim":"Acılı Lahmacun","fiyat":85,"ikon":"🫓","kategori":"Lahmacun"},
    {"isim":"Döner (Tabak)","fiyat":200,"ikon":"🥙","kategori":"Döner"},
    {"isim":"Yarım Döner","fiyat":120,"ikon":"🥙","kategori":"Döner"},
    {"isim":"Ayran","fiyat":30,"ikon":"🥛","kategori":"İçecek"},
    {"isim":"Kola","fiyat":40,"ikon":"🥤","kategori":"İçecek"},
    {"isim":"Su","fiyat":15,"ikon":"💧","kategori":"İçecek"},
    {"isim":"Çay","fiyat":15,"ikon":"🍵","kategori":"İçecek"},
    {"isim":"Cacık","fiyat":45,"ikon":"🥗","kategori":"Yan Ürün"},
    {"isim":"Mercimek Çorbası","fiyat":60,"ikon":"🍲","kategori":"Çorba"}
  ]'::jsonb
);

-- ============================================================
-- KURULUM TAMAMLANDI ✅
-- ============================================================
