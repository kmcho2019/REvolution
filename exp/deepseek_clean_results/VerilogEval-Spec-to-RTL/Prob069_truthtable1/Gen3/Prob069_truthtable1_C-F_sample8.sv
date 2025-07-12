module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire case1 = ~x3 & x2;  // First case: x3=0 and x2=1
    wire case2 = x3 & x1;   // Second case: x3=1 and x1=1
    assign f = case1 | case2;
endmodule