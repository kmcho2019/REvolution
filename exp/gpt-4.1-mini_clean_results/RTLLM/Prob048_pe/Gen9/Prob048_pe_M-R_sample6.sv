module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Register to hold the current product
    reg [63:0] product_reg;
    // Accumulator register to hold sum of products
    reg [63:0] acc_reg;

    // Compute product combinationally
    wire [63:0] product = a * b;

    // Pipeline stage 1: register the product
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= product;
        end
    end

    // Pipeline stage 2: accumulate the registered product
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 64'd0;
        end else begin
            acc_reg <= acc_reg + product_reg;
        end
    end

    // Output lower 32 bits of accumulator
    assign c = acc_reg[31:0];

endmodule