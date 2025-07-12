module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Register to hold the product - pipelining multiplication
    reg [63:0] product_reg;

    // 64-bit accumulator register
    reg [63:0] acc;

    // Combinational product of inputs
    wire [63:0] product = a * b;

    // Stage 1: Register the product to break combinational path
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= product;
        end
    end

    // Stage 2: Accumulate the registered product with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product_reg;
        end
    end

    // Output the lower 32 bits of accumulator as the result
    assign c = acc[31:0];

endmodule