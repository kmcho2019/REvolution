module TopModule (
    input x,
    input y,
    output z
);
    // Optimized XNOR implementation using basic gates
    wire x_and_y, nx_and_ny;
    
    assign x_and_y = x & y;
    assign nx_and_ny = ~x & ~y;
    assign z = x_and_y | nx_and_ny;
endmodule