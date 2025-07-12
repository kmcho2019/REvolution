module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] temp_sum;

    // Perform binary addition of A, B, and Cin
    assign temp_sum = A + B + Cin;

    // BCD correction: if sum exceeds 9, add 6
    assign Sum = (temp_sum > 9) ? (temp_sum + 6)[3:0] : temp_sum[3:0];

    // Carry generation: if result exceeds 9, generate Cout
    assign Cout = (temp_sum > 9) ? 1'b1 : ((temp_sum + 6) > 9) ? 1'b1 : 1'b0;

endmodule