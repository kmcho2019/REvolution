module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire or_bc = b | c;
    assign q = a ? (or_bc & (b | ~a)) : or_bc;

endmodule