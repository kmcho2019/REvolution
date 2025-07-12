module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input         Cin,  // Carry-in input
    output  [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output        Cout  // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_temp;
    assign sum_temp = A + B + Cin;

    // Check if the sum exceeds 9 and needs correction
    wire [3:0] sum_corrected;
    wire        correction_needed;
    assign correction_needed = (sum_temp > 9) ? 1'b1 : 1'b0;

    // Apply correction if needed
    assign sum_corrected = (correction_needed) ? (sum_temp + 6) : sum_temp;

    // Ensure the sum is within the 4-bit range (discard any high bits)
    assign Sum = sum_corrected[3:0];

    // Determine carry-out based on whether correction was needed and the result of the addition
    assign Cout = (sum_temp > 9) || (sum_corrected > 9) ? 1'b1 : 1'b0;

endmodule