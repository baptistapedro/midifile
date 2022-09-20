FROM fuzzers/afl:2.52 as builder

RUN apt-get update && apt-get install -y cmake
ADD . /midifile
WORKDIR /midifile
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ .
RUN make
RUN mkdir /midcorpus
ADD /testcase/* /midcorpus

FROM fuzzers/afl:2.52

COPY --from=builder /midifile/miditime /
COPY --from=builder /midcorpus /testsuite

ENTRYPOINT ["afl-fuzz", "-i", "/testsuite", "-o", "/midifileOut"]
CMD ["/miditime", "@@"]
