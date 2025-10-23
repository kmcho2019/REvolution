module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire b_or_c;
    assign b_or_c = b | c;
    assign q = b_or_c;
endmodule