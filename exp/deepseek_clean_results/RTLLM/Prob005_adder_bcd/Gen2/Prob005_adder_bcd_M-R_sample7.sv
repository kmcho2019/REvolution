module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [4:0] binary_sum = A + B + Cin;  // 5-bit sum including carry
wire needs_correction = (binary_sum > 9) | binary_sum[4];  // Detect invalid BCD
wire [3:0] corrected_sum = binary_sum[3:0] + 4'b0110;      // Correction value

assign Sum = needs_correction ? corrected_sum : binary_sum[3:0];
assign Cout = needs_correction;

endmodule