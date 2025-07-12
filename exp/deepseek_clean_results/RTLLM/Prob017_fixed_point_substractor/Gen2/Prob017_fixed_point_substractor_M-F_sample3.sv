module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits (default 16)
    parameter N = 32    // Total number of bits (default 32)
) (
    input wire signed [N-1:0] a,  // First fixed-point operand
    input wire signed [N-1:0] b,  // Second fixed-point operand
    output reg signed [N-1:0] c   // Fixed-point result
);

    // Fixed-point subtraction with proper sign handling
    always @(*) begin
        // Direct signed subtraction handles all cases
        c = a - b;
        
        // Explicit zero handling: clear sign bit when result is zero
        if (c[N-2:0] == 0) begin
            c[N-1] = 1'b0;
        end
    end

endmodule