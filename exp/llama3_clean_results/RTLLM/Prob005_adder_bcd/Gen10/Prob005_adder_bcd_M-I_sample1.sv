module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [4:0] sum_bin = A + B + Cin;
wire is_overflow = sum_bin > 9;

assign Sum = is_overflow ? (sum_bin + 4'd6)[3:0] : sum_bin[3:0];
assign Cout = is_overflow | sum_bin[4];

endmodule