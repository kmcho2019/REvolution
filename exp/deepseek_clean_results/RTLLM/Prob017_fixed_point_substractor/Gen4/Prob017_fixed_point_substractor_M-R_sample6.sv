module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits (default 16)
    parameter N = 32    // Total number of bits (default 32)
) (
    input wire signed [N-1:0] a,  // First fixed-point operand (Q.N format)
    input wire signed [N-1:0] b,  // Second fixed-point operand (Q.N format)
    output wire signed [N-1:0] c  // Fixed-point result (Q.N format)
);

    // Parameter validation
    generate
        if (Q >= N) begin
            initial $error("Invalid parameters: Q (%0d) must be less than N (%0d)", Q, N);
        end
    endgenerate

    // Internal result before zero handling
    wire signed [N-1:0] raw_result = a - b;

    // Final result with zero handling
    assign c = (|raw_result[N-2:0]) ? raw_result : {1'b0, {N-1{1'b0}}};

endmodule