module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output Cout      // Carry-out output
);

// Temporary wires for the binary sum and the carry before correction
wire [4:0] bin_sum;
wire carry_before_correction;

// Perform binary addition of A, B, and Cin
assign bin_sum = A + B + Cin;

// Generate carry-out if the sum exceeds 9 before correction
assign carry_before_correction = (bin_sum > 4'd9) ? 1'b1 : 1'b0;

// Correction and final sum calculation
always @(A, B, Cin) begin
    if (bin_sum > 4'd9) begin
        // Apply correction if sum exceeds 9
        Sum = bin_sum + 4'd6;
    end else begin
        // No correction needed if sum is within BCD range
        Sum = bin_sum[3:0];
    end
end

// Assign carry-out based on whether the sum before correction exceeds 9
assign Cout = carry_before_correction;

endmodule