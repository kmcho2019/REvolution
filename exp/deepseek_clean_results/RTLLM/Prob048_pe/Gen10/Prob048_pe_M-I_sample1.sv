module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [15:0] a_hi, a_lo, b_hi, b_lo;
    reg signed [31:0] stage1_prod_hi, stage1_prod_lo, stage1_prod_mid;
    reg signed [31:0] stage2_sum;
    
    // Zero detection for power gating
    wire inputs_zero = (a == 0) || (b == 0);
    
    // Stage 1: 16x16 partial products
    always @(posedge clk) begin
        if (rst) begin
            a_hi <= 0; a_lo <= 0;
            b_hi <= 0; b_lo <= 0;
        end else if (!inputs_zero) begin
            a_hi <= a[31:16];
            a_lo <= a[15:0];
            b_hi <= b[31:16];
            b_lo <= b[15:0];
        end
    end
    
    // Stage 2: Partial product calculation
    always @(posedge clk) begin
        if (rst) begin
            stage1_prod_hi <= 0;
            stage1_prod_lo <= 0;
            stage1_prod_mid <= 0;
        end else if (!inputs_zero) begin
            stage1_prod_hi <= a_hi * b_hi;
            stage1_prod_lo <= a_lo * b_lo;
            stage1_prod_mid <= (a_hi * b_lo) + (a_lo * b_hi);
        end
    end
    
    // Stage 3: Final sum and accumulation
    always @(posedge clk) begin
        if (rst) begin
            stage2_sum <= 0;
            c <= 0;
        end else if (inputs_zero) begin
            // Maintain current value when inputs are zero
            stage2_sum <= 0;
        end else begin
            // Final product sum with proper shifting
            stage2_sum <= (stage1_prod_hi << 32) + (stage1_prod_mid << 16) + stage1_prod_lo;
            
            // Saturation logic for overflow protection
            if (~(c[31] ^ stage2_sum[31]) && (c[31] ^ (c + stage2_sum[31:0])[31])) begin
                c <= c[31] ? 32'h80000000 : 32'h7FFFFFFF; // Saturate
            end else begin
                c <= c + stage2_sum[31:0];
            end
        end
    end

endmodule