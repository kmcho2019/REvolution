module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire sel = a | b;
    wire cd_or = c | d;
    assign q = sel ? cd_or : 1'b0;
endmodule