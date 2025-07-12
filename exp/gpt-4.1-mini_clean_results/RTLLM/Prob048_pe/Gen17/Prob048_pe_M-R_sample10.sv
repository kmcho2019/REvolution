module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg  [63:0] product_reg;
    reg  [31:0] acc;
    wire [32:0] sum_ext;
    wire        overflow;

    // Stage 1: Register the product on clk edge
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= a * b;
        end
    end

    // Sum extended with carry-out for overflow detection
    assign sum_ext = {1'b0, acc} + product_reg[31:0];
    assign overflow = sum_ext[32];

    // Stage 2: Accumulate with saturation
    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
        end else begin
            if (overflow)
                acc <= 32'hFFFF_FFFF;
            else
                acc <= sum_ext[31:0];
        end
    end

    assign c = acc;

endmodule