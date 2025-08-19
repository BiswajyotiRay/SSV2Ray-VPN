## **Shadowsocks + V2Ray plugin**

### Overview
Self-Hosting Personal free VPN Service by integrating Shadowsocks with the V2Ray plugin.

### Features
- Common encryption methods: **aes-128-gcm**, **aes-256-gcm**, **chacha20-ietf-poly1305**, **xchacha20-ietf-poly1305** 
- **ProxySite** making it much harder for censorship systems to identify and block your server's IP address. (Set any Domain,e.g. cdnjs.com)
- Deployable to **Serverless platforms** (Heroku, Fly.io, Railway, Koyab, etc)

### Installation & Usage
   Rename .env.sample to .env and fill the values

   Deploy directly with Dockerfile + env vars

### Clients

| Platform   | Client | Download |
|------------|--------|----------|
| **Android** | Shadowsocks (official) | [Download APK](https://github.com/shadowsocks/shadowsocks-android/releases) |
|            | V2Ray Plugin (required) | [Download APK](https://github.com/shadowsocks/v2ray-plugin-android/releases/) |
| **Windows** | Shadowsocks-Windows | [GitHub Releases](https://github.com/shadowsocks/shadowsocks-windows/releases) |
|            | V2Ray Plugin | [GitHub Releases](https://github.com/shadowsocks/v2ray-plugin/releases) |
| **Linux**  | Shadowsocks-libev | [Docs & Packages](https://github.com/shadowsocks/shadowsocks-libev) |
|            | V2Ray Plugin | [GitHub Releases](https://github.com/shadowsocks/v2ray-plugin/releases) |
| **macOS**  | Shadowsocks-NG | [GitHub Releases](https://github.com/shadowsocks/ShadowsocksX-NG/releases) |
|            | V2Ray Plugin | [GitHub Releases](https://github.com/shadowsocks/v2ray-plugin/releases) |


### References & Resources

[Shadowsocks](https://hub.docker.com/r/shadowsocks/shadowsocks-libev) – reliable VPN proxy protocol

[V2Ray](https://github.com/shadowsocks/v2ray-plugin) – advanced, flexible network tunneling tool

[v2ray-heroku-undone](https://github.com/xiangrui120/v2ray-heroku-undone) - One-click deployment of v2ray to heroku