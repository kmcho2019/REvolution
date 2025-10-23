module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire not_x3;
    wire term1, term2;
    
    assign not_x3 = ~x3;
    assign term1 = not_x3 & x2;
    assign term2 = x3 & x1;
    assign f = term1 | term2;
endmodule