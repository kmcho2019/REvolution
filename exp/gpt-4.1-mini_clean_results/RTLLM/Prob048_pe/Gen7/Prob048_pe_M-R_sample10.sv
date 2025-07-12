module pe (
    input wire clk,
    input wire rst,             // synchronous reset: active high
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    reg [63:0] acc;
    reg [63:0] product_reg;
    wire [63:0] product;

    // Combinational multiplication
    assign product = a * b;

    // Register the product to create a pipeline stage
    always @(posedge clk) begin
        if (rst)
            product_reg <= 64'd0;
        else
            product_reg <= product;
    end

    // Accumulate the registered product
    always @(posedge clk) begin
        if (rst)
            acc <= 64'd0;
        else
            acc <= acc + product_reg;
    end

    assign c = acc[31:0];

endmodule