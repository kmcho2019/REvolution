module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous reset: active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    reg  [63:0] product_reg;
    reg  [63:0] acc;

    wire [63:0] product = a * b;

    // Register the product to pipeline multiplication and accumulation
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= product;
        end
    end

    // Accumulate the registered product
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product_reg;
        end
    end

    assign c = acc[31:0];

endmodule