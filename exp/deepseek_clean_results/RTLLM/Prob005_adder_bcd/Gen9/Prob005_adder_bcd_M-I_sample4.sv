module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute 4-bit sum and carry
    wire [3:0] sum4;
    wire carry4;
    assign {carry4, sum4} = A + B + Cin;

    // Correction needed if:
    // - Binary sum > 9 (1001) OR
    // - Carry generated from 4-bit addition
    // Optimized pattern: sum4[3] & (sum4[2] | sum4[1])
    wire correction_needed = carry4 | (sum4[3] & (sum4[2] | sum4[1]));

    // Apply correction and generate final sum and carry
    assign Sum = sum4 + (correction_needed ? 4'd6 : 4'd0);
    assign Cout = correction_needed;

endmodule