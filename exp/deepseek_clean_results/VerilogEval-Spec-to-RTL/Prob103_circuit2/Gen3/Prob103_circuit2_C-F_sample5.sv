module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Efficient even parity check using XOR
    assign q = ~(a ^ b ^ c ^ d);

endmodule