module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (documentation)
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Absolute values (with extra bit for overflow detection)
    wire [N-1:0] a_abs = {1'b0, a_mag};
    wire [N-1:0] b_abs = {1'b0, b_mag};

    // Magnitude comparison
    wire a_gt_b = (a_abs > b_abs);
    wire mag_equal = (a_abs == b_abs);

    // Arithmetic results
    wire [N-1:0] sum = a_abs + b_abs;
    wire [N-1:0] diff = a_gt_b ? (a_abs - b_abs) : (b_abs - a_abs);

    always @(*) begin
        // Default assignment
        c = {N{1'b0}};

        // Same sign case
        if (a_sign == b_sign) begin
            if (~sum[N-1]) begin  // No overflow
                c = {a_sign, sum[N-2:0]};
            end else begin         // Overflow - saturate
                c = {a_sign, {N-1{~a_sign}}};
            end
        end
        // Different signs case
        else begin
            if (mag_equal) begin
                c = {N{1'b0}};  // Zero result
            end else begin
                c = {a_gt_b ? a_sign : b_sign, diff[N-2:0]};
            end
        end
    end

endmodule