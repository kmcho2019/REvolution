module TopModule (
    input x,
    input y,
    output z
);
    // Implement XNOR using fundamental gates
    wire x_and_y;
    wire not_x_and_not_y;
    
    assign x_and_y = x & y;
    assign not_x_and_not_y = ~x & ~y;
    assign z = x_and_y | not_x_and_not_y;
endmodule