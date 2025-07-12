module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] product_reg;
    wire signed [31:0] product = a * b;  // 32x32->32 multiplication

    // First pipeline stage: Register multiplication result
    always @(posedge clk) begin
        product_reg <= product;
    end

    // Second pipeline stage: Accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + product_reg;
        end
    end

endmodule