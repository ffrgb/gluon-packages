gluon-segment-mover
============

Requests Nodes to change to another domain_code

GLUON_SITE_FEEDS="ffrgb"<br>
PACKAGES_FFRGB_REPO=https://github.com/eulenfunk/packages.git<br>
PACKAGES_FFRGB_COMMIT=*/missing/*<br>
PACKAGES_FFRGB_BRANCH=master<br>

Then add the package *gluon-segment-mover* to site.mk


Cronjob that asks a Director Server, if the Node should move to another Segment.
This is mainly for Migration purposes when Domainsplits are done and can be
removed from the firmware when everything is done.

UCI Keys:
- currentsite.current.override='false': Preserves Segment, even if Gateway requests relocation
- gluon.system.domaincode: Node Domain Code