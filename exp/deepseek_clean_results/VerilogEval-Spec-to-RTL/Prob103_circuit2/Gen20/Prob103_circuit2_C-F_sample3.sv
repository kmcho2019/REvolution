module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Even parity check using single XNOR operation
    assign q = ~(a ^ b ^ c ^ d);

endmodule