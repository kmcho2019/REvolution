module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [4:0] bin_sum;
    assign bin_sum = A + B + Cin;
    assign Cout = (bin_sum > 9);
    assign Sum = (bin_sum > 9) ? (bin_sum[3:0] + 4'd6) : bin_sum[3:0];
endmodule