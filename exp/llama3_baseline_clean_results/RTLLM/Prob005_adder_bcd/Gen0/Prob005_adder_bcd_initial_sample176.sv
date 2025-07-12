module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition of A, B, and Cin
wire [4:0] temp_sum = A + B + Cin;

// Apply BCD correction if the sum exceeds 9
assign Sum = (temp_sum > 9) ? (temp_sum + 6) : temp_sum;
assign Cout = (temp_sum > 9) ? 1'b1 : 1'b0;

// To ensure Sum is only 4 bits, we need to correct the above assignment
assign Sum = (temp_sum > 9) ? (temp_sum[3:0] + 4'd6) : temp_sum[3:0];

// However, Cout should be generated based on temp_sum exceeding 9 or temp_sum + 6 exceeding 15
assign Cout = (temp_sum > 9) ? 1'b1 : (temp_sum + 4'd6 > 15) ? 1'b1 : 1'b0;

endmodule