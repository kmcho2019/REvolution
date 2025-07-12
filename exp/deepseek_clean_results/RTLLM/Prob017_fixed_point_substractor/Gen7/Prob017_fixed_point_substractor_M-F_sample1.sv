module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    // Internal signals
    wire signed [N-1:0] diff;
    wire a_sign, b_sign;
    wire signs_equal;
    wire a_gt_b_mag;
    wire is_zero;

    // Basic arithmetic operation
    assign diff = a - b;

    // Sign detection
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    assign signs_equal = (a_sign == b_sign);

    // Magnitude comparison (absolute values)
    assign a_gt_b_mag = (a_sign == b_sign) ? (a > b) : 
                       (a_sign ? (b > -a) : (a > -b));

    // Zero detection
    assign is_zero = (a == b);

    // Result calculation
    always @(*) begin
        if (is_zero) begin
            c = 0;
        end
        else if (signs_equal) begin
            c = diff;
        end
        else begin
            c = a_gt_b_mag ? diff : diff;
            // Sign will be automatically correct from the subtraction
        end
    end

endmodule