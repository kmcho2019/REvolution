module binary_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [4:0] Sum
);

    assign Sum = A + B + Cin;

endmodule

module bcd_corrector(
    input [4:0] Sum,
    output [3:0] Corrected_Sum,
    output Cout
);

    wire [3:0] lower_bits = Sum[3:0];
    wire carry = Sum[4];

    assign Cout = carry || (lower_bits > 4'd9);
    assign Corrected_Sum = (lower_bits > 4'd9) ? (lower_bits + 4'd6) : lower_bits;

endmodule

module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] binary_sum;

    binary_adder adder(
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(binary_sum)
    );

    bcd_corrector corrector(
        .Sum(binary_sum),
        .Corrected_Sum(Sum),
        .Cout(Cout)
    );

endmodule