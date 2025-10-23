module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;

    // Binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // If the sum exceeds 9 (1001 in binary), add 6 (0110 in binary) to correct it
    assign Sum = (binary_sum > 9) ? binary_sum + 6 : binary_sum;

    // Generate Cout if the result of the addition exceeds 9
    assign Cout = (binary_sum > 9) ? 1'b1 : (binary_sum == 9 && Cin == 1'b1) ? 1'b1 : 1'b0;

    // To ensure Sum is always 4 bits, truncate if necessary
    assign Sum = Sum[3:0];

endmodule