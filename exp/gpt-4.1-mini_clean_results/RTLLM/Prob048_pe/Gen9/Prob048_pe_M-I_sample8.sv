module pe (
    input               clk,
    input               rst,
    input               en,         // Enable accumulator update
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    // Pipeline registers for inputs
    reg [31:0] a_reg, b_reg;
    // Registered product (pipeline stage 1)
    reg [63:0] product_reg;
    // Accumulator (stage 2)
    reg [63:0] accumulator;

    // Output lower 32 bits of accumulator
    assign c = accumulator[31:0];

    always @(posedge clk) begin
        if (rst) begin
            a_reg       <= 32'd0;
            b_reg       <= 32'd0;
            product_reg <= 64'd0;
            accumulator <= 64'd0;
        end else begin
            // Register inputs to pipeline multiplier
            a_reg <= a;
            b_reg <= b;

            // Compute product combinationally and register it
            product_reg <= a_reg * b_reg;

            // Accumulate product if enabled
            if (en) begin
                accumulator <= accumulator + product_reg;
            end
        end
    end

endmodule