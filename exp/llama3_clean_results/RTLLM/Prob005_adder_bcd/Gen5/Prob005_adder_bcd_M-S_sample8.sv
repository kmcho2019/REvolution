module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition
wire [4:0] sum_bin = A + B + Cin;

// Apply BCD correction if necessary and generate carry-out
assign Cout = sum_bin[4];
assign Sum = (sum_bin < 10) ? sum_bin[3:0] : sum_bin[3:0] + 6;

endmodule