module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Operand isolation during reset
    wire signed [31:0] a_eff = rst ? 32'b0 : a;
    wire signed [31:0] b_eff = rst ? 32'b0 : b;
    
    // Pipeline stage 1: Multiplication
    reg signed [63:0] product_reg;
    wire signed [63:0] product = a_eff * b_eff;
    
    // Pipeline stage 2: Accumulation
    reg signed [31:0] sum_reg;
    wire signed [31:0] sum = c + product_reg[31:0];
    
    // Clock gating enable
    wire clk_en = ~rst;
    
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'b0;
            sum_reg <= 32'b0;
            c <= 32'b0;
        end else if (clk_en) begin
            // Pipeline stage 1: Register multiplication result
            product_reg <= product;
            
            // Pipeline stage 2: Register sum result
            sum_reg <= sum;
            
            // Final output update
            c <= sum_reg;
        end
    end

endmodule