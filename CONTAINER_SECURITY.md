```markdown
# 🐋 Container Security Best Practices

## Vulnerabilidades Corrigidas

### 1. Imagem Base
- ❌ Antes: `node:14` (desatualizada, muitas vulnerabilidades)
- ✅ Depois: `node:20-alpine` (atual, mínima)
- ✅ Melhor: `gcr.io/distroless/nodejs20` (sem shell, ultra-mínima)

### 2. Usuário Root
- ❌ Antes: Executando como root (UID 0)
- ✅ Depois: Usuário `nodejs` (UID 1001)

### 3. Camadas e Cache
- ❌ Antes: `COPY . .` (invalida cache facilmente)
- ✅ Depois: Multi-stage build + copy separado de dependencies

### 4. Filesystem
- ❌ Antes: Filesystem read-write
- ✅ Depois: `read_only: true` com tmpfs para temporários

### 5. Capabilities
- ❌ Antes: `privileged: true` + `SYS_ADMIN`
- ✅ Depois: `cap_drop: ALL` + apenas necessárias

### 6. Volumes Sensíveis
- ❌ Antes: `/var/run/docker.sock` montado
- ✅ Depois: Sem volumes sensíveis

## Comparação de Imagens

| Aspecto | Vulnerável | Alpine Secure | Distroless |
|---------|------------|---------------|------------|
| Tamanho | ~900MB | ~180MB | ~160MB |
| CVEs CRITICAL | ~15 | ~2 | ~0 |
| CVEs HIGH | ~45 | ~5 | ~1 |
| Usuário | root | nodejs | nonroot |
| Shell | ✅ | ✅ | ❌ |
| Package Manager | ✅ | ✅ | ❌ |

## Práticas Implementadas

### Build Time
- [x] Multi-stage builds
- [x] .dockerignore configurado
- [x] Layer caching otimizado
- [x] Dependências apenas de produção
- [x] Limpeza de cache após instalação

### Runtime
- [x] Usuário não-root
- [x] Read-only filesystem
- [x] Capabilities mínimas
- [x] Health checks
- [x] Resource limits
- [x] No new privileges
- [x] Tmpfs para temporários

### Monitoramento
- [x] Health checks automáticos
- [x] Restart policy configurada
- [x] Logs estruturados

## Comandos Úteis

### Build Seguro
```bash
docker build -f Dockerfile.secure -t myapp:secure .
```

### Run com Segurança Máxima
```bash
docker run -d \
  --name myapp \
  --read-only \
  --cap-drop=ALL \
  --security-opt=no-new-privileges:true \
  --user 1001:1001 \
  -p 3000:3000 \
  myapp:secure
```

### Verificar Configurações de Segurança
```bash
docker inspect myapp | jq '.[].HostConfig | {
  Privileged,
  ReadonlyRootfs,
  CapDrop,
  SecurityOpt
}'
```

## Scanners Utilizados

- **Trivy**: Scanner de vulnerabilidades da Aqua Security
- **Grype**: Scanner da Anchore
- **Docker Scout**: Scanner nativo do Docker

## Referências

- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [OWASP Docker Security](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
- [Distroless Containers](https://github.com/GoogleContainerTools/distroless)
```
