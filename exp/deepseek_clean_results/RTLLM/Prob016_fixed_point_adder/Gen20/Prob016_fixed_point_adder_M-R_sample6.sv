module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    // Internal signals for overflow detection
    wire signed [N:0] extended_sum;  // Extra bit for overflow detection

    always @(*) begin
        // Perform the addition with extended precision
        extended_sum = {a[N-1], a} + {b[N-1], b};
        
        // Handle normal case (no overflow)
        c = extended_sum[N-1:0];
        
        // Overflow detection (unused but available)
        if ((extended_sum[N] != extended_sum[N-1]) && 
            (a[N-1] == b[N-1])) begin
            // Overflow occurred - left for future handling
        end
    end

endmodule