module pe (
    input           clk,
    input           rst,    // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Stage 1: multiply inputs
    reg [63:0] product_reg;

    // Stage 2: accumulator register
    reg [31:0] acc;

    // Wires for addition and overflow detection
    wire [32:0] sum_ext;
    wire overflow;

    // Pipeline multiplication
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= a * b;
        end
    end

    // Add lower 32 bits of product_reg to acc, detect overflow
    assign sum_ext = {1'b0, acc} + product_reg[31:0];
    assign overflow = sum_ext[32];

    // Accumulator update with saturation and synchronous reset
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

    // Output accumulator value (1 cycle latency from input)
    assign c = acc;

endmodule