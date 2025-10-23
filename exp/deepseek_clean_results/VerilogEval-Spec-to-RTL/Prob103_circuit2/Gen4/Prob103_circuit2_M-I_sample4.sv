module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Most concise and clear implementation
    assign q = ~(a ^ b ^ c ^ d);

endmodule