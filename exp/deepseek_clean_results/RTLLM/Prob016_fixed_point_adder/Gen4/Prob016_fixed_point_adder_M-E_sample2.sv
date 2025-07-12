module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Extended precision signals
    wire signed [N:0] ext_a = {a[N-1], a};
    wire signed [N:0] ext_b = {b[N-1], b};
    reg signed [N:0] ext_sum;

    // Overflow detection signals
    wire overflow_pos, overflow_neg;

    always @(*) begin
        // Perform addition in extended precision
        ext_sum = ext_a + ext_b;

        // Detect overflow conditions
        overflow_pos = (~a[N-1] & ~b[N-1] & ext_sum[N]);
        overflow_neg = (a[N-1] & b[N-1] & ~ext_sum[N]);

        // Apply saturation if overflow occurs
        if (overflow_pos) begin
            c = {1'b0, {(N-1){1'b1}};  // Max positive
        end
        else if (overflow_neg) begin
            c = {1'b1, {(N-1){1'b0}};   // Max negative
        end
        else begin
            c = ext_sum[N-1:0];         // Normal case
        end
    end

endmodule