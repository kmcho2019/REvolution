module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition of A, B, and Cin
    reg [4:0] temp_sum;
    assign temp_sum = A + B + Cin;

    // BCD correction and carry generation
    assign Cout = (temp_sum > 9)? 1'b1 : 1'b0;
    assign Sum = (temp_sum > 9)? (temp_sum + 6)[3:0] : temp_sum[3:0];

endmodule