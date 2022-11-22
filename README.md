# CNCF Webinar - Sigstore Policy Controller Demo Files

[Recording](https://youtu.be/q0Kh5-94Vcw)

## Setup

You can use any image but these are the steps I followed:
1. Copy over a new image
```
crane copy \
    cgr.dev/chainguard/hello-world@sha256:f6827ec9bd51ad519e6e3aabb2e18487a852b34f57178166f8f70b81bff89b26 \
    gcr.io/image-scans/cncf-webinar:custom
```

2. Sign the image using cosign
```
cosign sign \
    gcr.io/image-scans/cncf-webinar@sha256:f6827ec9bd51ad519e6e3aabb2e18487a852b34f57178166f8f70b81bff89b26
```

3. Sign and attach the attestation to the image
```
cosign attest \
    --predicate=codereview.json \
    --type=custom \
    gcr.io/image-scans/cncf-webinar@sha256:f6827ec9bd51ad519e6e3aabb2e18487a852b34f57178166f8f70b81bff89b26
```

Signing the image generated log index [6691159](https://rekor.tlog.dev/?logIndex=6691159) and signing/attaching the attestation generated log index [6691180](https://rekor.tlog.dev/?logIndex=6691159)

In addition to the links to the public rekor log, the signature can be validated by running:
```
cosign verify gcr.io/image-scans/cncf-webinar@sha256:f6827ec9bd51ad519e6e3aabb2e18487a852b34f57178166f8f70b81bff89b26
```
The attestation can be shown by running:
```
cosign verify-attestation \
    --type=custom \
    gcr.io/image-scans/cncf-webinar@sha256:f6827ec9bd51ad519e6e3aabb2e18487a852b34f57178166f8f70b81bff89b26 \
    | jq -r .payload | base64 -d | jq -r .predicate.Data
```

Follow the rest of the instructions to learn how to validate the attestation

## Demo 1: Validate Repo Data

```
cosign verify-attestation \
    --policy=repo-check.cue \
    --type=custom \
    gcr.io/image-scans/cncf-webinar@sha256:f6827ec9bd51ad519e6e3aabb2e18487a852b34f57178166f8f70b81bff89b26
```

## Demo 2: Validate Email Domain of Author

```
cosign verify-attestation \
    --policy=author-email.cue \
    --type=custom \
    gcr.io/image-scans/cncf-webinar@sha256:f6827ec9bd51ad519e6e3aabb2e18487a852b34f57178166f8f70b81bff89b26
```

## Demo 3: Independent Review

```
cosign verify-attestation \
    --policy=independent-review.cue \
    --type=custom \
    gcr.io/image-scans/cncf-webinar@sha256:f6827ec9bd51ad519e6e3aabb2e18487a852b34f57178166f8f70b81bff89b26
```

## Demo 4: Putting It All Together

```
cosign verify-attestation \
    --policy=combined-trimmed.cue \
    --type=custom \
    gcr.io/image-scans/cncf-webinar@sha256:f6827ec9bd51ad519e6e3aabb2e18487a852b34f57178166f8f70b81bff89b26
```

### Chainguard Enforce

Turn on enforcement by adding the policy.sigstore.dev/include=true label, install the policy, run the example:
```
kubectl label ns default policy.sigstore.dev/include=true --overwrite
chainctl policies create --group $DEMO_GROUP -f codereview-cip.yaml
kubectl run codereview --image=gcr.io/image-scans/cncf-webinar@sha256:f6827ec9bd51ad519e6e3aabb2e18487a852b34f57178166f8f70b81bff89b26
```
Clean up
```
chainctl policy delete -y $(chainctl policy list -o json | jq -r '[.items[] | select(.name == "codereview")][0].id')
kubectl label ns default policy.sigstore.dev/include-
```
