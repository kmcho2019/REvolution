module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire term1 = ~x3 & x2;  // First case: x3=0 and x2=1
    wire term2 = x3 & x1;   // Second case: x3=1 and x1=1
    assign f = term1 | term2;
endmodule