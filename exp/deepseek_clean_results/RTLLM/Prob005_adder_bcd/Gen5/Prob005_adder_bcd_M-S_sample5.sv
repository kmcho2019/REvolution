module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // 4-bit sum with carry-out
    wire [3:0] sum;
    wire carry;
    assign {carry, sum} = A + B + Cin;

    // Correction needed if sum > 9 or carry occurred
    wire correction_needed = carry | (sum > 9);

    // Apply correction and generate outputs
    assign Sum = sum + (correction_needed ? 4'd6 : 4'd0);
    assign Cout = correction_needed;

endmodule