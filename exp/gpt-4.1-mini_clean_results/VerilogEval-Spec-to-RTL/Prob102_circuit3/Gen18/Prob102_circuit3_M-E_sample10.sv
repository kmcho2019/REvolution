module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire x = a | b;
    wire y = c | d;
    assign q = x & y;
endmodule