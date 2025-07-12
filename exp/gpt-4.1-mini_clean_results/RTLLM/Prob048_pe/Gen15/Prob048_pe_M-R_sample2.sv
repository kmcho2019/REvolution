module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] product_reg;
    reg [63:0] acc_reg;

    // Register the product of a and b on each clock cycle
    always @(posedge clk) begin
        if (rst)
            product_reg <= 64'd0;
        else
            product_reg <= a * b;
    end

    // Accumulate the registered product into a 64-bit accumulator
    always @(posedge clk) begin
        if (rst)
            acc_reg <= 64'd0;
        else
            acc_reg <= acc_reg + product_reg;
    end

    // Output the lower 32 bits of the accumulator as the accumulated result
    assign c = acc_reg[31:0];

endmodule