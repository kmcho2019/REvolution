module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] temp_sum = A + B + Cin;
    wire correction_needed = (temp_sum > 9);

    assign Sum = correction_needed ? temp_sum[3:0] + 4'd6 : temp_sum[3:0];
    assign Cout = correction_needed;

endmodule