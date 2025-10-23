module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition of A, B, and Cin
wire [4:0] sum_temp = A + B + Cin;

// Check if the sum exceeds 9 and generate the carry-out accordingly
assign Cout = (sum_temp > 9) ? 1'b1 : 1'b0;

// Apply BCD correction if necessary
assign Sum = (sum_temp > 9) ? (sum_temp + 6) : sum_temp;

// Ensure Sum is 4 bits by masking off the higher bits
assign Sum = Sum[3:0];

endmodule