module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Alternative implementation showing all cases where output is 1
    // This matches the K-map by covering all input combinations except a=b=c=0
    assign out = (a & ~b & ~c) |  // a=1, b=0, c=0
                 (~a & b & ~c) |  // a=0, b=1, c=0
                 (~a & ~b & c) |  // a=0, b=0, c=1
                 (a & b & ~c) |   // a=1, b=1, c=0
                 (a & ~b & c) |   // a=1, b=0, c=1
                 (~a & b & c) |   // a=0, b=1, c=1
                 (a & b & c);     // a=1, b=1, c=1
endmodule