module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] raw_sum = A + B + Cin;
    assign Cout = (raw_sum > 9);
    assign Sum = Cout ? raw_sum[3:0] + 4'd6 : raw_sum[3:0];

endmodule