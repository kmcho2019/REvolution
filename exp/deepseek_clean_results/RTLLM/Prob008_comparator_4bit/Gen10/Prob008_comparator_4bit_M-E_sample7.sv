module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Generate thermometer codes
    wire [15:0] therm_A = {16{1'b1}} << A;
    wire [15:0] therm_B = {16{1'b1}} << B;

    // Comparison logic
    wire gt = |(therm_A & ~therm_B);
    wire eq = &(A ~^ B);
    wire lt = |(~therm_A & therm_B);

    // Output assignment
    assign A_greater = gt;
    assign A_equal = eq;
    assign A_less = lt;

endmodule