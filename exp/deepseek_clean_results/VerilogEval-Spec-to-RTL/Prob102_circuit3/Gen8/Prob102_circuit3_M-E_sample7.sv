module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire sel = a | b;
    wire data = c | d;
    assign q = sel ? data : 1'b0;
endmodule