module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;
    reg [63:0] acc;

    // Stage 1: Register inputs and compute product
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product_reg <= 64'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= a_reg * b_reg;
        end
    end

    // Stage 2: Accumulate product into acc
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product_reg;
        end
    end

    // Output: lower 32 bits of accumulator (wrap-around behavior)
    assign c = acc[31:0];

endmodule