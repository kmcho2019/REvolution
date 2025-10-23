module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg a_sign, b_sign;
    reg [N-1:0] a_mag, b_mag;
    reg [N-1:0] sum;
    reg [N-1:0] diff;
    wire a_gt_b;

    always @(*) begin
        // Extract signs
        a_sign = a[N-1];
        b_sign = b[N-1];
        
        // Get magnitudes (absolute values)
        a_mag = a_sign ? -a : a;
        b_mag = b_sign ? -b : b;
        
        // Comparison for subtraction case
        a_gt_b = (a_mag > b_mag);
        
        if (a_sign == b_sign) begin
            // Same sign case - addition
            sum = a_mag + b_mag;
            
            // Check for overflow (result sign differs from input signs)
            if (sum[N-1] != a_sign && sum[N-2:0] != {(N-1){1'b0}}) begin
                // Saturate to maximum representable value
                c = {a_sign, {(N-1){1'b1}}};
            end else begin
                c = {a_sign, sum[N-2:0]};
            end
        end else begin
            // Different signs - subtraction
            if (a_gt_b) begin
                diff = a_mag - b_mag;
                c = {a_sign, diff[N-2:0]};
            end else begin
                diff = b_mag - a_mag;
                c = {b_sign, diff[N-2:0]};
            end
            
            // Special case: result is zero
            if (a_mag == b_mag) begin
                c = {N{1'b0}};
            end
        end
    end

endmodule