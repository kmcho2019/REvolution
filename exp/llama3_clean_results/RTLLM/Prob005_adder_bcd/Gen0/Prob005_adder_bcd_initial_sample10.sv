module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition
wire [4:0] sum_bin = A + B + Cin;

// Assign Cout if sum exceeds 9 (binary 1001) or if there's a carry from the addition
assign Cout = (sum_bin > 9) | (sum_bin[4]);

// Apply BCD correction if necessary
assign Sum = (sum_bin <= 9)? sum_bin[3:0] : (sum_bin[3:0] + 4'd6);

endmodule