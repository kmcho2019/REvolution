module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Stage 1: Binary Addition
wire [4:0] sum_bin = A + B + Cin;

// Stage 2: BCD Correction and Carry Generation
wire [3:0] sum_corrected = (sum_bin[4]) ? (sum_bin[3:0] + 4'd6) : sum_bin[3:0];
assign Cout = sum_bin[4];
assign Sum = sum_corrected;

endmodule