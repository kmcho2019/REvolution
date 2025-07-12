module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Convert inputs to sign-magnitude format
    wire a_sign = a[N-1];
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    
    wire b_sign = b[N-1];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];
    
    // Early sign determination
    wire a_gt_b = (a_mag > b_mag);
    wire result_sign = (a_sign & b_sign) ? (a_gt_b ? 1'b1 : 1'b0) :
                      (a_sign & ~b_sign) ? 1'b1 :
                      (~a_sign & b_sign) ? 1'b0 :
                      (a_gt_b ? 1'b0 : 1'b1);
    
    // Magnitude calculation
    wire [N-2:0] mag_diff;
    wire mag_overflow;
    
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same signs: subtract magnitudes
            {mag_overflow, mag_diff} = a_mag - b_mag;
        end else begin
            // Different signs: add magnitudes
            {mag_overflow, mag_diff} = a_mag + b_mag;
        end
    end
    
    // Zero detection and result formation
    wire is_zero = (a == b) || (mag_diff == 0);
    assign c = is_zero ? {N{1'b0}} : {result_sign, mag_diff};
    
    // Overflow detection
    assign overflow = (a_sign == b_sign) && 
                     (mag_overflow || (result_sign != a_sign)) &&
                     !is_zero;

endmodule