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
    wire signs_equal = ~(a_sign ^ b_sign);
    
    // Combined magnitude comparison and sign check
    wire a_gt_b_mag = (a[N-2:0] > b[N-2:0]);
    wire b_gt_a_mag = (b[N-2:0] > a[N-2:0]);
    wire mag_equal = (a[N-1:0] == b[N-1:0]);
    
    // Arithmetic operations
    wire [N:0] sum_ext = {a_sign, a} + {b_sign, b};
    wire [N:0] diff_ext = a_gt_b_mag ? {1'b0, a} - {1'b0, b} : {1'b0, b} - {1'b0, a};
    
    // Overflow detection
    wire add_overflow = signs_equal & (sum_ext[N] != sum_ext[N-1]);
    wire sub_overflow = ~signs_equal & (diff_ext[N] != 1'b0);
    
    // Result selection
    always @(*) begin
        if (mag_equal) begin
            c = {N{1'b0}};  // Zero result
        end
        else if (signs_equal) begin
            if (add_overflow) begin
                // Saturate to max positive/negative
                c = {a_sign, {(N-1){~a_sign}}};
            end else begin
                c = sum_ext[N-1:0];
            end
        end
        else begin
            if (sub_overflow) begin
                // Shouldn't happen for proper subtraction
                c = {N{1'b0}};
            end else begin
                c = {a_gt_b_mag ? a_sign : b_sign, diff_ext[N-2:0]};
            end
        end
    end

    // Zero detection optimization
    wire is_zero = (c == {N{1'b0}});
    always @(*) begin
        if (is_zero) c = {N{1'b0}};
    end

endmodule