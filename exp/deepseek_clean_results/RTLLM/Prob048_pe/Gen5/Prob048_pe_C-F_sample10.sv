module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [31:0] product;
    
    // Stage 1: Input registration and multiplication
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            product <= a_reg * b_reg;  // 32-bit signed multiplication
        end
    end
    
    // Stage 2: Accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + product;
        end
    end

endmodule