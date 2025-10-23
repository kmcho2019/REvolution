module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire [3:0] inputs = {a, b, c, d};
    assign q = ~(^inputs);
endmodule