module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

// Internal signals for the binary sum and carry
reg [4:0] bin_sum;

// Perform binary addition of A, B, and Cin
always @(*) begin
    bin_sum = A + B + Cin;
end

// Assign the Sum output, considering the BCD correction
assign Sum = (bin_sum > 9) ? bin_sum + 6 : bin_sum[3:0];

// Generate the carry-out signal if the binary sum exceeds 9
assign Cout = (bin_sum > 9) ? 1'b1 : 1'b0;

endmodule