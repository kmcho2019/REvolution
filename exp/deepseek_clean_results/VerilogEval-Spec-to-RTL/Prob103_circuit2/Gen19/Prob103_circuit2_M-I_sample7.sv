module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Direct even parity check using XNOR operations
    assign q = ~(a ^ b ^ c ^ d);

endmodule