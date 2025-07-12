module TopModule (
    input a,
    input b,
    input c,
    output out
);
    assign out = (a & b & c) |  // 111
                 (a & b & ~c) | // 110
                 (a & ~b & c) | // 101
                 (a & ~b & ~c) | // 100
                 (~a & b & c) | // 011
                 (~a & b & ~c) | // 010
                 (~a & ~b & c); // 001
    // Only case not covered is 000 which gives 0
endmodule