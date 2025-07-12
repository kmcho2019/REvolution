module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout     // Carry-out output
);

// Temporary sum without BCD correction
wire [4:0] temp_sum;

// Perform binary addition
assign temp_sum = A + B + Cin;

// Apply BCD correction and generate carry-out
always @(temp_sum) begin
    if (temp_sum > 9) begin
        // Add 6 for BCD correction and set carry-out
        Sum = temp_sum + 6;
        Cout = 1'b1;
    end else begin
        // No correction needed, just assign the sum
        Sum = temp_sum[3:0];
        Cout = 1'b0;
    end
end

endmodule