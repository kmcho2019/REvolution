module pe (
    input               clk,
    input               rst,       // synchronous reset, active high
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    reg  [63:0] accumulator;
    reg  [63:0] product_reg;
    wire [63:0] product;

    // Combinational multiplier
    assign product = a * b;

    // Pipeline stage 1: register product
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= product;
        end
    end

    // Pipeline stage 2: accumulate registered product
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