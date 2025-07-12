module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Stage 1 registers: register inputs and compute product
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;

    // Stage 2 register: accumulator register
    reg [31:0] acc;

    wire [32:0] sum_ext;
    wire overflow;

    // Pipeline stage 1: register inputs and compute product
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product_reg <= 64'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= a_reg * b_reg;
        end
    end

    // Extended sum for overflow detection
    assign sum_ext = {1'b0, acc} + product_reg[31:0];

    // Overflow occurs if MSB of sum_ext is set
    assign overflow = sum_ext[32];

    // Pipeline stage 2: accumulator update with saturation and synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
        end else begin
            if (overflow)
                acc <= 32'hFFFF_FFFF; // Saturate at max 32-bit value
            else
                acc <= sum_ext[31:0];
        end
    end

    // Output accumulator value
    assign c = acc;

endmodule