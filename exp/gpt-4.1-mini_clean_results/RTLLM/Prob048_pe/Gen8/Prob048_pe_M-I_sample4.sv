module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous active-high reset
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    // Stage 1: compute product combinationally
    wire [63:0] product = a * b;

    // Register to hold the product (pipeline register)
    reg [63:0] product_reg;

    // 64-bit accumulator register
    reg [63:0] acc;

    // Pipeline registers: register the product first, then accumulate
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
            acc <= 64'd0;
        end else begin
            product_reg <= product;
            acc <= acc + product_reg;
        end
    end

    // Output the lower 32 bits of accumulator
    assign c = acc[31:0];

endmodule