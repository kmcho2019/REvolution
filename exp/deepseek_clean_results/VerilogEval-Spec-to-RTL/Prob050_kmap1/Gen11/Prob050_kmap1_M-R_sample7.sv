module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Implement 3-input OR using two 2-input OR gates
    wire or_ab;
    or U1 (or_ab, a, b);
    or U2 (out, or_ab, c);
endmodule