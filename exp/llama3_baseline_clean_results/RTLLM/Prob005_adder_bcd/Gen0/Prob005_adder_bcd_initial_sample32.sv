module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition of A, B, and Cin
wire [4:0] raw_sum = A + B + Cin;

// Check if the raw sum exceeds 9 and apply correction
assign Cout = (raw_sum > 9) ? 1'b1 : 1'b0;

// Apply correction if raw sum exceeds 9
assign Sum = (raw_sum > 9) ? raw_sum[3:0] + 4'd6 : raw_sum[3:0];

endmodule