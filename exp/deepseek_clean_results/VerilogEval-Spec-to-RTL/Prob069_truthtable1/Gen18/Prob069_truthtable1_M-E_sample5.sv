module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire condition1 = ~x3 & x2;  // x3=0 and x2=1
    wire condition2 = x3 & x1;   // x3=1 and x1=1
    
    assign f = condition1 | condition2;
endmodule