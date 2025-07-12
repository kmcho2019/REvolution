module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

reg signed [31:0] product_reg;
reg signed [31:0] acc_reg;

always @(posedge clk) begin
    if (rst) begin
        product_reg <= 32'd0;
        acc_reg <= 32'd0;
        c <= 32'd0;
    end
    else begin
        // Stage 1: Multiply
        product_reg <= a * b;
        
        // Stage 2: Accumulate
        acc_reg <= acc_reg + product_reg;
        
        // Output stage
        c <= acc_reg;
    end
end

endmodule