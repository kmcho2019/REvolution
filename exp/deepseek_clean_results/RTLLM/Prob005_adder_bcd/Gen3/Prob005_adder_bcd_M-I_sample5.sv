module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [3:0] binary_sum;
wire carry_detect;

// Binary addition and carry detection
assign binary_sum = A + B + Cin;
assign carry_detect = (binary_sum > 9) | (A + B + Cin > 15);

// Corrected sum (binary_sum + 0 or 6)
assign Sum = carry_detect ? (binary_sum + 6) : binary_sum;
assign Cout = carry_detect;

endmodule