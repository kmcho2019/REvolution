module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimal XOR implementation for checkerboard K-map
    assign out = a ^ b ^ c ^ d;
endmodule