module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] binary_sum = A + B + Cin;

    assign Cout = (binary_sum > 4'd9)? 1'b1 : 1'b0;
    assign Sum = (binary_sum > 4'd9)? (binary_sum + 4'd6)[3:0] : binary_sum[3:0];

endmodule