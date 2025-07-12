module fixed_point_adder #(
    parameter integer Q = 8,   // Number of fractional bits
    parameter integer N = 16   // Total bits including sign bit
)(
    input  wire signed [N-1:0] a,  // Fixed-point signed input a
    input  wire signed [N-1:0] b,  // Fixed-point signed input b
    output reg  signed [N-1:0] c   // Fixed-point signed output
);

    // Wider register to hold addition result including potential overflow bit
    reg signed [N:0] sum_ext;

    // Maximum and minimum values representable in N-bit signed fixed point
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};            // max positive: 0 followed by all 1s
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};            // min negative: 1 followed by all 0s (most negative)

    always @* begin
        sum_ext = a + b;  // Perform addition in N+1 bits to detect overflow
        
        // Overflow detection:
        // Overflow occurs if sign of a == sign of b and sign of sum != sign of a
        if ((a[N-1] == b[N-1]) && (sum_ext[N] != sum_ext[N-1])) begin
            // Saturate output to max or min based on sign of inputs
            if (a[N-1] == 1'b0)
                c = MAX_VAL;   // Positive overflow saturates to max positive
            else
                c = MIN_VAL;   // Negative overflow saturates to max negative
        end else begin
            // No overflow: assign truncated sum to output
            c = sum_ext[N-1:0];
        end
    end

endmodule