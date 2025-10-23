module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [15:0] a_low, a_high;
    reg signed [15:0] b_low, b_high;
    reg signed [31:0] product_stage1;
    
    // Clock gating signals
    wire inputs_zero = (a == 0) && (b == 0);
    wire clk_en = ~inputs_zero && ~rst;

    // Stage 1: Split operands and compute partial products
    always @(posedge clk) begin
        if (rst) begin
            a_low <= 16'd0;
            a_high <= 16'd0;
            b_low <= 16'd0;
            b_high <= 16'd0;
        end else if (clk_en) begin
            a_low <= a[15:0];
            a_high <= a[31:16];
            b_low <= b[15:0];
            b_high <= b[31:16];
        end
    end

    // Stage 2: Combine partial products
    always @(posedge clk) begin
        if (rst) begin
            product_stage1 <= 32'd0;
        end else if (clk_en) begin
            product_stage1 <= (a_low * b_low) + 
                            ((a_high * b_low) << 16) + 
                            ((a_low * b_high) << 16);
        end
    end

    // Final accumulation stage with clock gating
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else if (clk_en) begin
            c <= c + product_stage1;
        end
    end

endmodule