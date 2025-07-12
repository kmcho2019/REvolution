module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition
wire [4:0] sum_bin = A + B + Cin;

// Generate carry-out
assign Cout = sum_bin[4]; // Simplified carry-out generation

// Apply BCD correction if necessary
wire [3:0] sum_corrected = sum_bin[3:0] + (sum_bin[4]? 4'd6 : 4'd0); // Use conditional operator for BCD correction

// Assign the corrected sum to the output
assign Sum = sum_corrected > 9? sum_corrected - 10 : sum_corrected; // Ensure the result does not exceed 9

endmodule