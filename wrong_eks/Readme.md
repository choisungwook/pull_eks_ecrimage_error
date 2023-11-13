# 개요
* 테라폼으로 EKS 생성

# 전제조건
* Administrator Policy를 갖는 AWS Profile(장애 데모여서 권한 제어는 하지 않았음)

# 네트워크 토폴로지

![](./imgs/network.png)


# 생성 방법
*  terraform apply는 timeout 발생(ECR image pull에러 때문에)

```bash
terraform init
terraform apply
```

# 디버깅 방법
* terraform apply timeout발생 이후(또는 Managed nodegroup 생성 중) kubectl로 디버깅

```bash
aws eks update-kubeconfig --region ap-northeast-2 --name eks-from-terraform
kubectl -n kube-system get pods
```

![](./imgs/pending.png)


# 삭제 방법

```bash
terrform destroy
```
