module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits (default 16)
    parameter N = 32    // Total number of bits (default 32)
) (
    input wire signed [N-1:0] a,  // First fixed-point operand (Q.N format)
    input wire signed [N-1:0] b,  // Second fixed-point operand (Q.N format)
    output wire signed [N-1:0] c  // Fixed-point result (Q.N format)
);

`ifdef SIMULATION
    initial begin
        if (Q >= N) begin
            $error("Invalid parameters: Q (%0d) must be less than N (%0d)", Q, N);
            $finish;
        end
    end
`endif

    // Internal signed subtraction
    wire signed [N-1:0] raw_result = a - b;

    // Optimized zero detection: check if magnitude is zero
    assign c = (raw_result[N-1:0] == {N{1'b0}}) ? {1'b0, {N-1{1'b0}}} : raw_result;

endmodule