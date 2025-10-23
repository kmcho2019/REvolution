module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Output is x2 when x3=0, x1 when x3=1
    assign f = (~x3 & x2) | (x3 & x1);
endmodule