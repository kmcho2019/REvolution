module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    wire m1, m2;

    assign m1 = (~x3) & x2;
    assign m2 = x3 & x1;
    assign f = m1 | m2;

endmodule