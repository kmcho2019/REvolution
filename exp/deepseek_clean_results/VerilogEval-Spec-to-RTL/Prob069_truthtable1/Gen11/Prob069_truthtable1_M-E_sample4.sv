module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire cond1 = ~x3 & x2;
    wire cond2 = x3 & ~x2 & x1;
    wire cond3 = x3 & x2 & x1;
    
    assign f = cond1 | cond2 | cond3;
endmodule