MailGunner
==========

MailGunner is a simple utility for quickly sending test HTML emails via MailGun. It let's you do your own [Litmus tests](http://litmus.com) with local versions of your HTML email.

#### Setup

First, create a `config.json` file based on `example_config.json` that looks like this:

```
{
    "apikey": "my-api-key",
    "sender": "me@example.com",
    "recipients": ["you@example.com"],
    "subject": "Test email sent via MailGunner"
}
```

#### Usage

```
coffee mailgunner.coffee /path/to/my/email.html
```

#### What MailGunner Does

MailGunner pulls out the contents of input file and sends that as an HTML email to the addresses you specify. Easy.
