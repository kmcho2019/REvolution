module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);
    assign out = (~sel & a[0]) | (sel & b[0]);
endmodule