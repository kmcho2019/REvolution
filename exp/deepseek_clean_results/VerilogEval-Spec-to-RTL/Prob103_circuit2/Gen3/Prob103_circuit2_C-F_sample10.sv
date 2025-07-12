module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    assign q = ~(a ^ b ^ c ^ d);  // Even parity checker (1 when even number of 1s)

endmodule