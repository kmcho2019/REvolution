module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    // Pipeline register for product to improve timing
    reg [47:0] product_pipe;

    // 48-bit product wire truncated from full 64-bit multiplication
    wire [63:0] full_product = a * b;
    wire [47:0] truncated_product = full_product[47:0];

    // 48-bit accumulator register
    reg [47:0] accum;

    // Clock gating enable: accumulate only if product not zero
    wire accumulate_enable = (truncated_product != 48'd0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_pipe <= 48'd0;
            accum <= 48'd0;
        end else begin
            product_pipe <= truncated_product;
            if (accumulate_enable)
                accum <= accum + product_pipe;
            else
                accum <= accum;  // Hold to reduce toggling
        end
    end

    // Output the lower 32 bits of the accumulator
    assign c = accum[31:0];

endmodule