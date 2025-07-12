module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Declare intermediate wires for partial sums
    wire partial_sum_0;
    wire partial_sum_1;
    wire final_sum;

    // Compute partial sums
    assign partial_sum_0 = in[0] + in[1];
    assign partial_sum_1 = partial_sum_0 + in[2];

    // Compute the final output
    assign out[0] = partial_sum_1;
    assign out[1] = (in[0] && in[1] && in[2]) || (in[0] && in[1] && ~in[2]) || (in[0] && ~in[1] && in[2]) || (~in[0] && in[1] && in[2]);

endmodule