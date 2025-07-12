module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in
    output [3:0] Sum, // 4-bit BCD sum output
    output Cout     // Carry-out
);

    // Temporary wires for intermediate calculations
    wire [4:0] temp_sum; // To hold the binary sum of A, B, and Cin
    wire [4:0] corrected_sum; // To hold the sum after BCD correction if necessary
    wire bcd_correction; // Flag to indicate if BCD correction is needed
    wire [3:0] correction_value; // The value to correct the sum to valid BCD

    // Perform binary addition of A, B, and Cin
    assign temp_sum = {A[3:0]} + {B[3:0]} + Cin;

    // Check if BCD correction is needed
    assign bcd_correction = (temp_sum > 4'd9); // If sum exceeds 9, correction is needed

    // Determine the correction value (6 in decimal or 0110 in binary)
    assign correction_value = (bcd_correction) ? 4'd6 : 4'd0;

    // Apply BCD correction if needed
    assign corrected_sum = {temp_sum[3:0]} + correction_value;

    // Assign the final sum
    assign Sum = corrected_sum[3:0];

    // Generate carry-out if the final sum exceeds 9
    assign Cout = (corrected_sum > 4'd9) ? 1'b1 : 1'b0;

endmodule