module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitudes (absolute values)
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];
    
    // Sign comparison
    wire same_sign = ~(a_sign ^ b_sign);
    
    // Arithmetic units
    wire [N-1:0] mag_sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] mag_diff = {1'b0, a_mag} - {1'b0, b_mag};
    
    // Result selection logic
    wire [N-2:0] res_mag;
    wire res_sign;
    
    always @(*) begin
        if (same_sign) begin
            // Same sign subtraction
            res_mag = mag_diff[N-2:0];
            res_sign = a_sign;  // Result inherits input signs
        end else begin
            // Different sign addition
            res_mag = mag_sum[N-2:0];
            res_sign = (a_mag > b_mag) ? a_sign : b_sign;
        end
        
        // Zero detection override
        if (res_mag == 0) begin
            res_sign = 1'b0;
        end
    end
    
    // Final result assembly
    assign c = {res_sign, res_mag};

endmodule