module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement as combination of AND and OR gates
    wire case1 = ~x3 & x2;  // x3=0 and x2=1
    wire case2 = x3 & x1;   // x3=1 and x1=1
    
    assign f = case1 | case2;
endmodule