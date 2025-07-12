module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum, // 4-bit output representing the sum
    output Cout      // Carry-out output
);

// Temporary wires for sum and carry
wire [4:0] temp_sum;

// Perform binary addition of A, B, and Cin
assign temp_sum = A + B + Cin;

// Check if the sum exceeds 9 and apply correction
always @(temp_sum) begin
    if (temp_sum > 9) begin
        // Add 6 to correct the sum to be within BCD range
        Sum = (temp_sum + 6) % 10;
        // Generate carry-out since the sum exceeded 9
        Cout = 1;
    end else begin
        // No correction needed, assign sum directly
        Sum = temp_sum[3:0];
        // No carry-out since the sum is within BCD range
        Cout = 0;
    end
end

endmodule