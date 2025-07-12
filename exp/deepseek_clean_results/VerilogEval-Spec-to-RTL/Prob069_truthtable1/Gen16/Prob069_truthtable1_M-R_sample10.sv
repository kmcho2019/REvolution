module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire not_x3;
    wire and1_out;
    wire and2_out;
    
    assign not_x3 = ~x3;
    assign and1_out = x3 & x1;
    assign and2_out = not_x3 & x2;
    assign f = and1_out | and2_out;
endmodule