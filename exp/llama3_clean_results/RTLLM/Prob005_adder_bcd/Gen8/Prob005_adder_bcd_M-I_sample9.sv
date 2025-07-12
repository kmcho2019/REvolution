module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition directly
wire [4:0] binary_sum = A + B + Cin;

// Determine if correction is needed
assign Cout = (binary_sum > 9) | binary_sum[4];

// Calculate the corrected sum directly
assign Sum = Cout ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];

endmodule