module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits (must be > Q)
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

    // Magnitude comparison
    wire a_gt_b;
    generate
        if (N > 1) begin : mag_compare
            assign a_gt_b = (a_mag > b_mag);
        end else begin
            assign a_gt_b = 1'b0;
        end
    endgenerate

    // Arithmetic operations
    wire [N-1:0] sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] diff = a_gt_b ? ({1'b0, a_mag} - {1'b0, b_mag}) 
                               : ({1'b0, b_mag} - {1'b0, a_mag});

    // Overflow detection
    wire sum_overflow = sum[N-1];  // Carry out from magnitude addition
    wire [N-1:0] saturated_sum = {a_sign, {N-1{!a_sign}}}; // Max positive or negative

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign addition
            if (sum_overflow) begin
                c = saturated_sum;  // Saturate on overflow
            end else begin
                c = {a_sign, sum[N-2:0]};
            end
        end else begin
            // Different sign subtraction
            if (a_gt_b) begin
                c = {a_sign, diff[N-2:0]};
            end else begin
                c = {b_sign, diff[N-2:0]};
            end
        end
    end

endmodule