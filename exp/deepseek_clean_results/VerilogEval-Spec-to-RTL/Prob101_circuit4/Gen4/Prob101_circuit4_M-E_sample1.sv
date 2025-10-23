module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire c_masked;
    assign c_masked = c & ~a;
    assign q = b | c_masked;

endmodule