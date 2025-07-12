module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly compute the binary sum of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;

    // Assign Cout directly based on binary_sum exceeding 9
    assign Cout = (binary_sum > 4'd9) ? 1'b1 : 1'b0;

    // Calculate the corrected sum in a single step, applying BCD correction if necessary
    assign Sum = (binary_sum > 4'd9) ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];

endmodule