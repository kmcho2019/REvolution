module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire [N:0] extended_sum;  // Extra bit for overflow detection
    wire overflow_positive, overflow_negative;
    wire sign_a, sign_b, sign_sum;

    // Direct two's complement addition
    assign extended_sum = {a[N-1], a} + {b[N-1], b};
    assign sign_sum = extended_sum[N];

    // Overflow detection
    assign overflow_positive = (~a[N-1] & ~b[N-1] & extended_sum[N-1]);
    assign overflow_negative = (a[N-1] & b[N-1] & ~extended_sum[N-1]);

    // Result selection with overflow handling
    always @(*) begin
        if (overflow_positive) begin
            // Positive overflow - saturate to max positive
            c = {1'b0, {(N-1){1'b1}}};
        end else if (overflow_negative) begin
            // Negative overflow - saturate to max negative
            c = {1'b1, {(N-1){1'b0}}};
        end else begin
            // No overflow - take normal result
            c = extended_sum[N-1:0];
        end
    end

endmodule