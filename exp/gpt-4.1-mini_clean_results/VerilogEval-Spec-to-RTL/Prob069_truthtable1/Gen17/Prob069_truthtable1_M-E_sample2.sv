module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    wire not_x3;
    assign not_x3 = ~x3;
    assign f = (not_x3 & x2) | (x3 & x1);
endmodule