### Report for Project 1

#### Design and Impl.

My tool is mainly a combination of AFL++ and SymQEMU.

There are three instance when running this tools:

* Master AFL++ Instance
* Secondary AFL++ Instance
* SymQEMU Instance

These three instances will exchange the seeds in the AFL_OUT_DIR and use afl-showmap to identify useful (interesting) seeds.

The Map Size of AFL++ is changed to 65536 make it work with SymQEMU.

#### Evaluation

I tested the tool with the 7 binaries provided and they all work.

I tested the tool with Accel with ~3000 seconds with 8 cores and recorded the edge coverage.

![imgs1](./imgs/edges.png)

![imgs](./imgs2/edges.png)

The image above is with symqemu and another is pure AFL++.

We can find that the final edge coverage after 50 minutes is around 1600~1650. However, the one with SymQEMU can achieve 1550 for an earlier time.