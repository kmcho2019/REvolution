module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous reset, active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    // Internal registered product to pipeline the multiplier output
    reg  [63:0] product_reg;
    // 64-bit accumulator register
    reg  [63:0] accumulator;

    // Combinational multiplier (32x32 -> 64 bits)
    wire [63:0] product;
    assign product = a * b;

    // Register the product on the clock edge
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= product;
        end
    end

    // Accumulate the registered product synchronously
    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else begin
            accumulator <= accumulator + product_reg;
        end
    end

    // Output the lower 32 bits of the accumulator
    assign c = accumulator[31:0];

endmodule