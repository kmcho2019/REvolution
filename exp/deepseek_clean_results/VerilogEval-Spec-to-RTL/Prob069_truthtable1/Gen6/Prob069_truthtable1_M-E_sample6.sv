module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);
    wire condition1, condition2;
    
    // First condition: x3=0 AND x2=1
    assign condition1 = ~x3 & x2;
    
    // Second condition: x3=1 AND x1=1
    assign condition2 = x3 & x1;
    
    // Final output is OR of both conditions
    assign f = condition1 | condition2;
endmodule