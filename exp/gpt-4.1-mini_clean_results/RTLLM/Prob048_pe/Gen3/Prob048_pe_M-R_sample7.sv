module pe (
    input wire clk,
    input wire rst,               // synchronous reset: active high
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    reg [63:0] product_reg;
    reg [32:0] sum_reg;

    wire [63:0] product = a * b;
    wire [32:0] sum = {1'b0, c} + {1'b0, product_reg[31:0]};

    // Stage 1: Register the product
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= product;
        end
    end

    // Stage 2: Accumulate registered product into c
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
            sum_reg <= 33'd0;
        end else begin
            sum_reg <= sum;
            c <= sum_reg[31:0];
        end
    end

endmodule