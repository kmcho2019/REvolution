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
    
    // Clock gating for multiplier (power optimization)
    wire gated_clk = clk & ~rst;
    
    // Operand isolation during reset (power optimization)
    wire signed [31:0] a_eff = rst ? 32'b0 : a;
    wire signed [31:0] b_eff = rst ? 32'b0 : b;
    
    // Stage 1: Input registration and multiplication
    always @(posedge gated_clk) begin
        a_reg <= a_eff;
        b_reg <= b_eff;
        product_reg <= a_eff * b_eff;
    end
    
    // Stage 2: Accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            // Basic accumulation with truncation
            c <= c + product_reg[31:0];
            
            /* Optional: Saturation logic
            if (product_reg > 32'sh7FFFFFFF - c)
                c <= 32'sh7FFFFFFF; // Saturate positive
            else if (product_reg < -32'sh80000000 - c)
                c <= -32'sh80000000; // Saturate negative
            else
                c <= c + product_reg[31:0];
            */
        end
    end

endmodule