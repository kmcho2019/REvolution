module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] binary_sum;
    wire carry_generated;
    wire sum_gt_9;
    wire correction_needed;

    // Binary addition of A, B, and Cin
    assign {carry_generated, binary_sum} = A + B + Cin;

    // Check if sum > 9 (1001) - equivalent to (sum[3] & (sum[2] | sum[1]))
    assign sum_gt_9 = (binary_sum > 4'd9);

    // Correction needed if either carry was generated or sum > 9
    assign correction_needed = carry_generated | sum_gt_9;

    // Final sum is binary_sum + 6 if correction needed, else binary_sum
    assign Sum = correction_needed ? (binary_sum + 4'd6) : binary_sum;

    // Carry out is set when correction is needed
    assign Cout = correction_needed;

endmodule