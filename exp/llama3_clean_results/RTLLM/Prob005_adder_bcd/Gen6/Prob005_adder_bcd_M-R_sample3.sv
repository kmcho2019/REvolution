module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Internal signal for the binary sum
wire [4:0] binary_sum;

// Perform binary addition
assign binary_sum = A + B + Cin;

// Determine if correction is needed (sum exceeds 9 or carry from addition)
wire correction_needed = (binary_sum > 9) | binary_sum[4];

// Calculate the corrected sum
wire [3:0] corrected_sum = correction_needed ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];

// Assign Cout based on the need for correction or carry from the addition
assign Cout = correction_needed;

// Assign the final Sum
assign Sum = corrected_sum;

endmodule