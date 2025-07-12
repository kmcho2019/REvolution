module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire f_x3_0, f_x3_1;
    
    // x3=0 case: output follows x2
    assign f_x3_0 = ~x3 & x2;
    
    // x3=1 case: output follows x1
    assign f_x3_1 = x3 & x1;
    
    // Combine both cases
    assign f = f_x3_0 | f_x3_1;
endmodule