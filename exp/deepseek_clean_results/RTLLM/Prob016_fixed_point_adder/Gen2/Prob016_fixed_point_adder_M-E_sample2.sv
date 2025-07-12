module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    // Internal signals
    reg signed [N:0] extended_sum;  // Extra bit for overflow detection
    wire overflow_positive;
    wire overflow_negative;

    always @(*) begin
        // Perform extended precision addition
        extended_sum = {a[N-1], a} + {b[N-1], b};
        
        // Detect overflow conditions
        overflow_positive = (~a[N-1] & ~b[N-1] & extended_sum[N]);
        overflow_negative = (a[N-1] & b[N-1] & ~extended_sum[N]);
        
        // Handle normal case and overflow cases
        if (overflow_positive) begin
            // Positive overflow - saturate to maximum positive value
            c = {1'b0, {(N-1){1'b1}};
        end else if (overflow_negative) begin
            // Negative overflow - saturate to minimum negative value
            c = {1'b1, {(N-1){1'b0}};
        end else begin
            // Normal case - truncate to N bits
            c = extended_sum[N-1:0];
        end
    end

endmodule