// Alternative 1: Using basic logic gates
module TopModule (
    input x,
    input y,
    output z
);
    wire x_nor, y_nor, and1, and2;
    
    assign x_nor = ~x;
    assign y_nor = ~y;
    assign and1 = x & y;
    assign and2 = x_nor & y_nor;
    assign z = and1 | and2;
endmodule