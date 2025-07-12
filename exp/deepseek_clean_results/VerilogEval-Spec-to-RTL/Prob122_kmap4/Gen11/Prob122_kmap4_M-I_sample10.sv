module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Output is 1 when (a XOR b) != (c XOR d)
    assign out = (a ^ b) ^ (c ^ d);

endmodule