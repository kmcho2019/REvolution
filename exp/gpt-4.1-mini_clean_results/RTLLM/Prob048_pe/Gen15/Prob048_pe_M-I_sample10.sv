module pe (
    input           clk,
    input           rst,    // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Stage 1 registers: register inputs and product
    reg [31:0] a_reg, b_reg;
    reg [63:0] product_reg;

    // Stage 2 register: accumulator
    reg [31:0] acc;

    wire [32:0] sum_ext;
    wire overflow;

    // Stage 1: Register inputs and product
    always @(posedge clk) begin
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

    // Compute extended sum and overflow in combinational domain based on registered product and accumulator
    assign sum_ext = {1'b0, acc} + product_reg[31:0];
    assign overflow = sum_ext[32];

    // Stage 2: Accumulate with saturation and synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
        end else begin
            if (overflow)
                acc <= 32'hFFFF_FFFF; // Saturate to max 32-bit unsigned
            else
                acc <= sum_ext[31:0];
        end
    end

    // Output driven directly from accumulator
    assign c = acc;

endmodule