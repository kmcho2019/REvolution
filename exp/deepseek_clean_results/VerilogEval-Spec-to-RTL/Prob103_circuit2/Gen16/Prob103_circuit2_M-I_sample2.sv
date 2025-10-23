module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Direct XNOR implementation in a single expression
    assign q = ~(a ^ b ^ c ^ d);

endmodule