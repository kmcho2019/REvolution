module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Convert to sign-magnitude representation
    wire a_sign = a[N-1];
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    
    wire b_sign = b[N-1];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Parallel addition paths
    wire [N-1:0] sum_pos, sum_neg;
    wire ovf_pos, ovf_neg;
    
    // Positive addition path (both numbers positive)
    wire [N-1:0] pos_sum = {1'b0, a_mag} + {1'b0, b_mag};
    assign sum_pos = pos_sum[N-1:0];
    assign ovf_pos = pos_pos[N];
    
    // Negative addition path (both numbers negative)
    wire [N-1:0] neg_sum = {1'b0, a_mag} + {1'b0, b_mag};
    assign sum_neg = {1'b1, neg_sum[N-2:0]};
    assign ovf_neg = neg_sum[N-1];
    
    // Subtraction path (different signs)
    wire [N-2:0] sub_mag;
    wire sub_sign;
    
    assign {sub_sign, sub_mag} = (a_mag >= b_mag) ? 
                                {a_sign, a_mag - b_mag} : 
                                {b_sign, b_mag - a_mag};
    
    // Result selection
    always @(*) begin
        if (a_sign == b_sign) begin
            if (a_sign) begin // Both negative
                c = ovf_neg ? {1'b1, {(N-1){1'b0}}} : sum_neg;
            end else begin    // Both positive
                c = ovf_pos ? {1'b0, {(N-1){1'b1}}} : sum_pos;
            end
        end else begin
            c = {sub_sign, sub_mag};
        end
    end

    // Fractional precision handling (implicit in the addition)
    // The Q parameter ensures proper alignment during arithmetic operations

endmodule