module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire not_x3_and_x2 = ~x3 & x2;  // First case: x3=0 and x2=1
    wire x3_and_x1 = x3 & x1;       // Second case: x3=1 and x1=1
    assign f = not_x3_and_x2 | x3_and_x1;
endmodule