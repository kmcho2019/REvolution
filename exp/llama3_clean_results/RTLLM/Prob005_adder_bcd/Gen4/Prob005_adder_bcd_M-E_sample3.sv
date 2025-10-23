module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition using a carry-lookahead adder
    wire [3:0] binary_sum;
    wire carry_out;
    assign {carry_out, binary_sum} = A + B + Cin;

    // Conditional correction logic
    wire correction_needed;
    assign correction_needed = (binary_sum > 4'd9);

    // Apply correction if needed
    wire [3:0] corrected_sum;
    assign corrected_sum = (correction_needed)? (binary_sum + 4'd6) : binary_sum;

    // Assign outputs
    assign Sum = corrected_sum;
    assign Cout = (carry_out || correction_needed);

endmodule