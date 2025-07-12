module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire case_x3_0 = ~x3 & x2;  // Covers x3=0 cases where f=1
    wire case_x3_1 = x3 & x1;   // Covers x3=1 cases where f=1
    
    assign f = case_x3_0 | case_x3_1;
endmodule