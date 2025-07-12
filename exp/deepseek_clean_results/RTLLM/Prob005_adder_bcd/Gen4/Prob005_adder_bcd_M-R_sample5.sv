module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary sum including carry-in (5 bits to catch overflow)
    wire [4:0] binary_sum = A + B + Cin;

    // Detect if correction needed (sum > 9 or carry occurred)
    wire needs_correction = (binary_sum > 9) | binary_sum[4];

    // Apply correction if needed (add 6) and generate carry
    assign Sum = needs_correction ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];
    assign Cout = needs_correction;

endmodule