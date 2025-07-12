module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Optimal implementation - keep original XOR solution
    assign out = (a ^ b) ^ (c ^ d);

endmodule