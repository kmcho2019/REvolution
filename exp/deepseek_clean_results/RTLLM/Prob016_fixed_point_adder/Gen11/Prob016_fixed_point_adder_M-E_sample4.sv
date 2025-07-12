module fixed_point_adder #(
    parameter Q = 8,        // Fractional bits
    parameter N = 16,       // Total bits
    parameter SATURATE = 1, // Enable saturation
    parameter ROUND = 0     // Enable rounding
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire ovf,        // Overflow flag
    output wire unf         // Underflow flag
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1 : b[N-2:0];

    // Intermediate signals
    wire [N-1:0] sum_raw;
    wire [N-1:0] diff_raw;
    wire cmp = (a_mag > b_mag);
    
    // Same sign addition
    wire [N:0] same_sign_sum = {a[N-1], a_mag} + {b[N-1], b_mag};
    
    // Different sign subtraction
    wire [N-1:0] diff_res = cmp ? (a_mag - b_mag) : (b_mag - a_mag);
    wire diff_sign = cmp ? a_sign : b_sign;
    
    // Result selection
    wire sign_equal = (a_sign == b_sign);
    wire [N-1:0] unsigned_res = sign_equal ? same_sign_sum[N-1:0] : diff_res;
    wire res_sign = sign_equal ? a_sign : (|unsigned_res ? diff_sign : 1'b0);
    
    // Apply rounding if enabled
    wire [N-1:0] rounded_res;
    generate
        if (ROUND && Q > 0) begin
            wire round_bit = unsigned_res[Q-1];
            wire [N-1:0] trunc_res = {unsigned_res[N-1:Q], {Q{1'b0}}};
            assign rounded_res = trunc_res + (round_bit ? (1 << Q) : 0);
        end else begin
            assign rounded_res = unsigned_res;
        end
    endgenerate
    
    // Final result with sign
    wire [N-1:0] signed_res = {res_sign, rounded_res[N-2:0]};
    
    // Overflow/underflow detection
    wire overflow = sign_equal && same_sign_sum[N];
    wire underflow = (res_sign && (rounded_res[N-2:0] == {N-1{1'b1}}));
    
    // Saturation logic
    generate
        if (SATURATE) begin
            assign c = overflow ? {a_sign, {N-1{~a_sign}}} : 
                      underflow ? {1'b1, {N-1{1'b0}}} : signed_res;
        end else begin
            assign c = signed_res;
        end
    endgenerate
    
    // Status flags
    assign ovf = overflow;
    assign unf = underflow;

endmodule