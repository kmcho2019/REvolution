module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Operand isolation with reset
    wire signed [31:0] a_eff = rst ? 32'sb0 : a;
    wire signed [31:0] b_eff = rst ? 32'sb0 : b;
    
    // Pipeline stage 1: Multiplication (registered)
    reg signed [63:0] product_reg;
    wire signed [63:0] product = a_eff * b_eff;
    
    // Pipeline stage 2: Accumulation
    always @(posedge clk) begin
        // Stage 1: Register product
        product_reg <= product;
        
        // Stage 2: Accumulate with synchronous reset
        if (rst) begin
            c <= 32'sb0;
        end else begin
            c <= c + product_reg[31:0]; // Truncated accumulation
        end
    end

endmodule