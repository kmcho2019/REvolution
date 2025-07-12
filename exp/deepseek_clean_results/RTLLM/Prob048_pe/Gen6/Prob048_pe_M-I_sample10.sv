module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [15:0] a_high, a_low, b_high, b_low;
    reg signed [31:0] stage1_result;
    wire signed [31:0] product;
    wire clk_en;
    
    // Clock gating when inputs are zero
    assign clk_en = (a != 0) || (b != 0);
    
    // Split operands into 16-bit chunks
    always @(posedge clk) begin
        if (clk_en) begin
            a_high <= a[31:16];
            a_low <= a[15:0];
            b_high <= b[31:16];
            b_low <= b[15:0];
        end
    end
    
    // First stage: Partial products
    always @(posedge clk) begin
        if (clk_en) begin
            stage1_result <= (a_high * b_low) + (a_low * b_high);
        end
    end
    
    // Second stage: Final product (32-bit)
    assign product = (a_high * b_high << 32) + (stage1_result << 16) + (a_low * b_low);
    
    // Carry-save accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else if (clk_en) begin
            c <= c + product;
        end
    end

endmodule