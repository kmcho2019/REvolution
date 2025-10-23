module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits (default 16)
    parameter N = 32    // Total number of bits (default 32)
) (
    input wire signed [N-1:0] a,  // First fixed-point operand (Q.N format)
    input wire signed [N-1:0] b,  // Second fixed-point operand (Q.N format)
    output reg signed [N-1:0] c   // Fixed-point result (Q.N format)
);

    // Parameter validation
    initial begin
        if (Q >= N) begin
            $error("Invalid parameters: Q (%0d) must be less than N (%0d)", Q, N);
        end
    end

    // Efficient fixed-point subtraction with optimized zero handling
    always @(*) begin
        // Direct signed subtraction handles all cases
        c = a - b;
        
        // Optimized zero detection: reduction OR for magnitude bits
        // Clear sign bit when all magnitude bits are zero
        c[N-1] = c[N-1] & (|c[N-2:0]);
    end

endmodule