module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [15:0] a_hi, a_lo, b_hi, b_lo;
    reg signed [31:0] product_hi, product_lo, product_mid;
    reg signed [31:0] stage1_sum;

    // Clock gating signal
    wire enable = |a || |b;

    // Pipeline stage 1: Split operands
    always @(posedge clk) begin
        if (rst) begin
            {a_hi, a_lo, b_hi, b_lo} <= 0;
        end else if (enable) begin
            a_hi <= a[31:16];
            a_lo <= a[15:0];
            b_hi <= b[31:16];
            b_lo <= b[15:0];
        end
    end

    // Pipeline stage 2: Partial products
    always @(posedge clk) begin
        if (rst) begin
            {product_hi, product_lo, product_mid} <= 0;
        end else if (enable) begin
            product_hi <= a_hi * b_hi;
            product_lo <= a_lo * b_lo;
            product_mid <= (a_hi * b_lo) + (a_lo * b_hi);
        end
    end

    // Pipeline stage 3: Final sum with saturation
    always @(posedge clk) begin
        if (rst) begin
            c <= 0;
            stage1_sum <= 0;
        end else if (enable) begin
            // Combine partial products with proper shifting
            stage1_sum <= (product_hi << 32) + (product_mid << 16) + product_lo;
            
            // Saturation logic for overflow protection
            if (~(c[31] ^ stage1_sum[31]) & (c[31] ^ (c + stage1_sum)[31]) begin
                c <= c[31] ? 32'h80000000 : 32'h7FFFFFFF;
            end else begin
                c <= c + stage1_sum[31:0];
            end
        end
    end

endmodule