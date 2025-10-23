module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Internal signal for the binary sum
    wire [4:0] binary_sum = A + B + Cin;

    // Simplified logic to determine if correction is needed
    assign Cout = (binary_sum > 9) || binary_sum[4];

    // Apply BCD correction and assign Sum
    assign Sum = (binary_sum[3:0] > 4'd9) ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];

endmodule