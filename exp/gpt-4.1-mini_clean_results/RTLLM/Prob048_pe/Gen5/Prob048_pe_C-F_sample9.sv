module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous reset, active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    reg  [63:0] product_reg;
    reg  [63:0] acc;

    wire [63:0] product;

    // Combinational 32x32 multiplication (64-bit product)
    assign product = a * b;

    // Pipeline register to hold the product (break critical path)
    always @(posedge clk) begin
        if (rst)
            product_reg <= 64'd0;
        else
            product_reg <= product;
    end

    // Accumulate the registered product into 64-bit accumulator
    always @(posedge clk) begin
        if (rst)
            acc <= 64'd0;
        else
            acc <= acc + product_reg;
    end

    // Output lower 32 bits of the accumulator
    assign c = acc[31:0];

endmodule