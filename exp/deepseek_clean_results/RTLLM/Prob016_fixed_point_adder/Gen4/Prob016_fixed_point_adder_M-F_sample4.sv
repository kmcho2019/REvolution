module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire same_sign = (a_sign == b_sign);
    wire a_abs_gt_b_abs = (a[N-2:0] >= b[N-2:0]);
    
    // Arithmetic operations
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;
    wire [N:0] sum = {1'b0, a_abs} + {1'b0, b_abs};
    wire [N-1:0] diff = a_abs_gt_b_abs ? (a_abs - b_abs) : (b_abs - a_abs);
    
    // Overflow detection
    wire overflow = sum[N];
    
    always @(*) begin
        if (same_sign) begin
            if (overflow) begin
                // Saturate to maximum value with same sign
                c = {a_sign, {(N-1){~a_sign}}};
            end else begin
                c = {a_sign, sum[N-1:0]};
            end
        end else begin
            if (a_abs_gt_b_abs) begin
                c = {a_sign, diff[N-2:0]};
            end else begin
                c = {b_sign, diff[N-2:0]};
            end
        end
    end

endmodule