module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Stage 1: multiply a and b, register product
    reg [63:0] product_reg;

    always @(posedge clk) begin
        if (rst)
            product_reg <= 64'd0;
        else
            product_reg <= a * b;
    end

    // Stage 2: accumulate with saturation
    reg [31:0] acc_reg;
    wire [32:0] sum_ext = {1'b0, acc_reg} + product_reg[31:0];
    wire overflow = sum_ext[32];

    always @(posedge clk) begin
        if (rst)
            acc_reg <= 32'd0;
        else if (overflow)
            acc_reg <= 32'hFFFF_FFFF;
        else
            acc_reg <= sum_ext[31:0];
    end

    assign c = acc_reg;

endmodule