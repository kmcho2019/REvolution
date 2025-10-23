module TopModule (
    input x,
    input y,
    output z
);
    wire x_eq_y;    // x equals y
    wire x_neq_y;   // x not equals y
    
    assign x_eq_y = ~(x ^ y);  // XNOR using XOR and NOT
    assign z = x_eq_y;
endmodule