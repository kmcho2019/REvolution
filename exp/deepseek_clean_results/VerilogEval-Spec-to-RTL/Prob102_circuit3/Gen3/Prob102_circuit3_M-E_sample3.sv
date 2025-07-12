module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire control = a | b;
    wire data = c | d;
    assign q = control ? data : 1'b0;
endmodule