module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    // Stage 1 registers: hold operands and product
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;

    // Stage 2 signals: accumulation
    wire [32:0] sum_ext;
    wire overflow;

    // Pipeline Stage 1: Register inputs and compute product
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product_reg <= 64'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= a * b;
        end
    end

    // Accumulation logic: sum current c with lower 32 bits of product from previous stage
    assign sum_ext = {1'b0, c} + product_reg[31:0];
    assign overflow = sum_ext[32];

    // Stage 2: Accumulate with saturation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            if (overflow)
                c <= 32'hFFFF_FFFF;
            else
                c <= sum_ext[31:0];
        end
    end

endmodule