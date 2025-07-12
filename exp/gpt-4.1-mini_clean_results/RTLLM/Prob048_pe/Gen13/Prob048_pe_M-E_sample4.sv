module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output      [31:0]  c
);

    reg [31:0] accum_a, accum_b;
    reg        toggle;
    wire [31:0] product;
    wire [32:0] sum_c;

    assign product = a * b;
    assign sum_c = {1'b0, accum_a} + {1'b0, accum_b};  // 33-bit sum to detect overflow
    assign c = sum_c[31:0]; // Output lower 32 bits of sum

    always @(posedge clk) begin
        if (rst) begin
            accum_a <= 32'd0;
            accum_b <= 32'd0;
            toggle <= 1'b0;
        end else begin
            toggle <= ~toggle;
            if (toggle) begin
                accum_a <= accum_a + product;
            end else begin
                accum_b <= accum_b + product;
            end
        end
    end

endmodule