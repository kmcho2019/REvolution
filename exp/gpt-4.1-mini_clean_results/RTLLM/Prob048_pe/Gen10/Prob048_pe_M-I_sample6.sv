module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    // Stage 1: multiply a and b, register the product
    reg [63:0] product_reg;

    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= a * b;
        end
    end

    // Stage 2: accumulate with saturation
    // Extended sum to detect overflow
    wire [32:0] sum_ext = {1'b0, c} + product_reg[31:0];
    wire overflow = sum_ext[32];

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            if (overflow)
                c <= 32'hFFFF_FFFF; // Saturate max 32-bit unsigned
            else
                c <= sum_ext[31:0];
        end
    end

endmodule