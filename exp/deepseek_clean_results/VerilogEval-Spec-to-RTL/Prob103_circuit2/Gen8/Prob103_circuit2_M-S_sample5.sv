module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    assign q = ~^ {a, b, c, d};  // XOR reduction with inversion for even parity

endmodule