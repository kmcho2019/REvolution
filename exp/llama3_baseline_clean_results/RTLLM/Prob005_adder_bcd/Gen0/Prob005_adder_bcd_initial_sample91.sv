module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] sum_temp;

    // Binary addition of A, B, and Cin
    assign sum_temp = A + B + Cin;

    // Check if sum exceeds 9 and apply correction
    assign Sum = (sum_temp > 9) ? (sum_temp + 6) : sum_temp;
    assign Cout = (sum_temp > 9) ? 1'b1 : 1'b0;

endmodule