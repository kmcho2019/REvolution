module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    // 64-bit register to hold the accumulated sum with full precision
    reg [63:0] acc;

    // Register to pipeline the product, breaking the combinational path
    reg [63:0] product_reg;

    wire [63:0] product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
            acc <= 64'd0;
            c <= 32'd0;
        end else begin
            product_reg <= product;      // pipeline product calculation
            acc <= acc + product_reg;    // accumulate previous cycle's product
            c <= acc[31:0];              // output lower 32 bits of accumulator
        end
    end

endmodule