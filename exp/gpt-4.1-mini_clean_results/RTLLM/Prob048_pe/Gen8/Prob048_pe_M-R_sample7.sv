module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    reg  [31:0] a_reg, b_reg;
    wire [63:0] product;
    reg  [63:0] accumulator;

    // Register inputs
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Combinational multiplication of registered inputs
    assign product = a_reg * b_reg;

    // Accumulate product to 64-bit accumulator
    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else begin
            accumulator <= accumulator + product;
        end
    end

    // Output lower 32 bits
    assign c = accumulator[31:0];

endmodule