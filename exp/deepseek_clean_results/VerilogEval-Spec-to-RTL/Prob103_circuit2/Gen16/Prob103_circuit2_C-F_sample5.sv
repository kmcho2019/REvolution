module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Even parity check using parallel XOR operations
    assign q = ~(a ^ b ^ c ^ d);

endmodule