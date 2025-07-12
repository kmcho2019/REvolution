module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    
    // Clock gating control
    wire clk_enable = ~rst;
    
    // Stage 1: Input registration and multiplication
    always @(posedge clk) begin
        if (clk_enable) begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= a * b;  // Full precision multiply
        end
    end
    
    // Stage 2: Accumulation with saturation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            // Saturation logic
            reg signed [63:0] sum;
            sum = { {32{c[31]}}, c } + product_reg;
            
            if (sum > $signed(64'h000000007FFFFFFF)) begin
                c <= 32'h7FFFFFFF;  // Positive saturation
            end else if (sum < $signed(64'hFFFFFFFF80000000)) begin
                c <= 32'h80000000;   // Negative saturation
            end else begin
                c <= sum[31:0];      // Normal case
            end
        end
    end

endmodule