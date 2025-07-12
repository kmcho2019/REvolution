module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Maintain the optimal XOR implementation
    assign out = (a ^ b) ^ (c ^ d);
endmodule