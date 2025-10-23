module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition directly
wire [4:0] binary_sum = A + B + Cin;

// Combine conditions for correction and carry generation
assign Cout = (binary_sum > 9);
assign Sum = (Cout) ? (binary_sum[3:0] + 6) : binary_sum[3:0];

endmodule