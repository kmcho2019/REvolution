module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Internal signals
    reg signed [31:0] acc_reg;
    reg signed [31:0] product_reg;
    wire signed [63:0] product_full;
    wire clk_en;
    
    // Clock gating when inputs are zero or reset is active
    assign clk_en = (|a || |b) && !rst;
    
    // Full precision product calculation
    assign product_full = a * b;
    
    // Output assignment
    assign c = acc_reg;
    
    // First pipeline stage: register multiplier output
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 32'd0;
        end else if (clk_en) begin
            product_reg <= product_full[31:0];
        end
    end
    
    // Second pipeline stage: accumulation
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 32'd0;
        end else if (clk_en) begin
            acc_reg <= acc_reg + product_reg;
        end
    end
    
endmodule