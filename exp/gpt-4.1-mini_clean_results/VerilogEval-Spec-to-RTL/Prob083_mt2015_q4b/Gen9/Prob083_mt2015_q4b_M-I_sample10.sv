module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    // Output z is high when inputs x and y are equal.
    // Using Verilog built-in XNOR operator for efficient synthesis.
    assign z = ~(x ^ y);
endmodule