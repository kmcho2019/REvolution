module TopModule(
    input  x,
    input  y,
    output z
);
    wire x_eq_y;
    assign x_eq_y = ~(x ^ y); // x_eq_y = 1 if x == y, else 0
    
    // Multiplexer: if x_eq_y=1, select 1; else select 0
    assign z = x_eq_y ? 1'b1 : 1'b0;
endmodule