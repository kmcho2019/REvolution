module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [4:0] sum_bin = A + B + Cin;

assign Sum = (sum_bin > 9)? sum_bin[3:0] + 4'd6 : sum_bin[3:0];
assign Cout = (sum_bin > 9) | sum_bin[4];

endmodule