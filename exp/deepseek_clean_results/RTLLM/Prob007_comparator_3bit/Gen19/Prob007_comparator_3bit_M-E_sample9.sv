module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Thermometer code generation
wire [7:0] therm_A = (8'b1 << A) - 1;
wire [7:0] therm_B = (8'b1 << B) - 1;

// Comparison logic
wire [7:0] and_result = therm_A & therm_B;

// Output determination
assign A_greater = (and_result == therm_B) && (therm_A != therm_B);
assign A_equal = (therm_A == therm_B);
assign A_less = (and_result == therm_A) && (therm_A != therm_B);

endmodule