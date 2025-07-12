module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Direct XOR implementation
    assign out = (a ^ b) ^ (c ^ d);

endmodule