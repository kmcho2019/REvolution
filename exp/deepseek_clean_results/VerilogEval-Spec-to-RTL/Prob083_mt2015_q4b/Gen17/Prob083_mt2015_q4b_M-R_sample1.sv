module TopModule (
    input x,
    input y,
    output z
);
    wire x_and_y;    // x AND y
    wire nx_and_ny;  // NOT x AND NOT y
    
    assign x_and_y = x & y;
    assign nx_and_ny = ~x & ~y;
    assign z = x_and_y | nx_and_ny;  // XNOR implemented as (x AND y) OR (NOT x AND NOT y)
endmodule