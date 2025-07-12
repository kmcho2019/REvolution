module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    assign q = (c | d) ? ((a | b) ? 1'b1 : 1'b0) : 1'b0;
endmodule