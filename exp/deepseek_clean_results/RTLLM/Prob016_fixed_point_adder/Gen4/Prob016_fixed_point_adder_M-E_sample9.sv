module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Synthesizable parameter validation
    generate
        if (Q >= N) begin
            illegal_parameter_combination illegal();
        end
        if (N < 2) begin
            illegal_parameter_value illegal();
        end
    endgenerate

    // Sign extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude conversion (two's complement to sign-magnitude)
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];
    
    // Unified arithmetic operation
    wire [N-1:0] sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] diff = a_mag > b_mag ? {1'b0, a_mag - b_mag} : {1'b0, b_mag - a_mag};
    wire diff_sign = a_mag > b_mag ? a_sign : b_sign;
    
    // Priority encoder for magnitude comparison
    wire a_gt_b = |(a_mag & ~b_mag);
    wire b_gt_a = |(b_mag & ~a_mag);
    
    // Overflow detection (carry out of N-1 bit)
    wire overflow = sum[N-1];
    
    // Result selection
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign addition
            if (overflow) begin
                // Saturate to max/min value
                c = {a_sign, {(N-1){~a_sign}}};
            end else begin
                c = {a_sign, sum[N-2:0]};
            end
        end else begin
            // Different sign subtraction
            if (a_mag == b_mag) begin
                c = {N{1'b0}};  // Zero result
            end else begin
                c = {diff_sign, diff[N-2:0]};
            end
        end
    end

endmodule