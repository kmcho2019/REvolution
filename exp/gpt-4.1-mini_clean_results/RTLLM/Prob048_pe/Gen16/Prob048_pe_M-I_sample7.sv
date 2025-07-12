module pe (
    input           clk,
    input           rst,    // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    reg [63:0] product_reg;  // registered product
    reg [31:0] acc;

    // Stage 1: Multiply inputs and register the product
    wire [63:0] product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= product;
        end
    end

    // Stage 2: Accumulate lower 32 bits of product_reg
    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
            c <= 32'd0;
        end else begin
            acc <= acc + product_reg[31:0];
            c <= acc + product_reg[31:0]; // output updated same cycle as acc update for stable output
        end
    end

endmodule