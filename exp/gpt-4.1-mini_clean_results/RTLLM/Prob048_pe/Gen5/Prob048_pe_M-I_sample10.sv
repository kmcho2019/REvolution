module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // 64-bit accumulator register to hold full precision result
    reg [63:0] acc;

    // Pipeline register to hold the product
    reg [63:0] product_reg;

    // Combinational multiplier output
    wire [63:0] product = a * b;

    // Pipeline the product
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= product;
        end
    end

    // Accumulator register with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product_reg;
        end
    end

    // Output is lower 32 bits of the accumulator
    assign c = acc[31:0];

endmodule