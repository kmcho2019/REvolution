module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    reg  [63:0] accumulator;
    reg  [63:0] product_reg;
    wire [63:0] product;

    // Combinational multiplication
    assign product = a * b;

    // Register the product (pipeline stage 1)
    always @(posedge clk) begin
        if (rst)
            product_reg <= 64'd0;
        else
            product_reg <= product;
    end

    // Accumulate the registered product (pipeline stage 2)
    always @(posedge clk) begin
        if (rst)
            accumulator <= 64'd0;
        else
            accumulator <= accumulator + product_reg;
    end

    // Output lower 32 bits of the accumulator
    assign c = accumulator[31:0];

endmodule