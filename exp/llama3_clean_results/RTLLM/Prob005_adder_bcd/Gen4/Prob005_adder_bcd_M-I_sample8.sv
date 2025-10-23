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
assign Cout = sum_bin[4]; // Directly check the most significant bit

// Apply BCD correction if necessary
assign Sum = (sum_bin <= 9)? sum_bin[3:0] : (sum_bin[3:0] + 6); // Simplified BCD correction

endmodule