module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Direct 4-input even parity check using XNOR
    assign q = ~(a ^ b ^ c ^ d);

endmodule