module pe (
    input               clk,
    input               rst,       // asynchronous reset, active high
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    reg  [63:0] accumulator;
    reg  [63:0] product_reg;

    // Combinational logic: compute product of inputs
    always @(*) begin
        product_reg = a * b;
    end

    // Sequential logic: accumulate product, async reset active high
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else begin
            accumulator <= accumulator + product_reg;
        end
    end

    assign c = accumulator[31:0];

endmodule