module pe (
    input  wire         clk,
    input  wire         rst,
    input  wire [31:0]  a,
    input  wire [31:0]  b,
    output wire [31:0]  c
);

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;

    // 64-bit accumulator register
    reg [63:0] accum;

    // Stage 1: register inputs and compute product
    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
        product_reg <= a_reg * b_reg;
    end

    // Stage 2: accumulate product
    always @(posedge clk) begin
        if (rst) begin
            accum <= 64'd0;
        end else begin
            accum <= accum + product_reg;
        end
    end

    // Output the lower 32 bits of accumulator
    assign c = accum[31:0];

endmodule