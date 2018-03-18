# Ruby on Rails sample application

这是一个简单的微博类应用程序

## Getting started

使用下面的命令安装程序所需的依赖包

```
$ bundle install --without production
```

接下来，将模型映射到数据库

```
$ rails db:migrate
```

最后，测试一下它能否正常运行

```
$ rails test
```

如果测试通过，那么说明现在可以在本地正常运行了

```
$ rails server
```
