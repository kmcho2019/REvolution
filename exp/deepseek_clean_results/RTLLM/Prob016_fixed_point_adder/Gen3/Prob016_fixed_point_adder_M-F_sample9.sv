module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    // Internal signals
    wire same_sign;
    wire a_gt_b;
    wire signed [N:0] sum_ext;  // Extended by 1 bit for overflow detection
    wire signed [N-1:0] diff;
    wire overflow;

    // Sign comparison
    assign same_sign = (a[N-1] == b[N-1]);
    assign a_gt_b = (a[N-1] == b[N-1]) ? (a >= b) : (a[N-1] == 0);

    // Extended sum for overflow detection
    assign sum_ext = {a[N-1], a} + {b[N-1], b};
    assign overflow = (sum_ext[N] != sum_ext[N-1]);

    // Difference calculation
    assign diff = (a_gt_b) ? (a - b) : (b - a);

    always @(*) begin
        if (same_sign) begin
            if (overflow) begin
                // Saturate to max positive or negative
                c = a[N-1] ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
            end else begin
                c = a + b;
            end
        end else begin
            c = a_gt_b ? {a[N-1], diff[N-2:0]} : {b[N-1], diff[N-2:0]};
        end
    end

endmodule