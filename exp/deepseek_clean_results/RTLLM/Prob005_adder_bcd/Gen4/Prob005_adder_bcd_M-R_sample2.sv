module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] binary_sum;
    wire carry_out;
    wire correction_needed;

    // Binary addition (4-bit sum + carry out)
    assign {carry_out, binary_sum} = A + B + Cin;

    // Correction needed if sum > 9 or carry out from binary addition
    assign correction_needed = carry_out | (binary_sum > 4'd9);

    // Final sum: add 6 if correction needed, else pass through
    assign Sum = correction_needed ? (binary_sum + 4'd6) : binary_sum;

    // Carry out is simply the correction flag
    assign Cout = correction_needed;

endmodule