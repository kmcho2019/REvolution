module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    // Registered inputs to improve timing
    reg signed [WIDTH-1:0] a_reg, b_reg;
    always @(posedge clk) begin
        a_reg <= rst ? {WIDTH{1'b0}} : a;
        b_reg <= rst ? {WIDTH{1'b0}} : b;
    end

    // Pipeline stage 1: Multiplication
    reg signed [2*WIDTH-1:0] product_reg;
    wire signed [2*WIDTH-1:0] product = a_reg * b_reg;
    always @(posedge clk) begin
        product_reg <= product;
    end

    // Pipeline stage 2: Accumulation
    wire signed [WIDTH-1:0] truncated_product = product_reg[WIDTH-1:0];
    always @(posedge clk) begin
        if (rst) begin
            c <= {WIDTH{1'b0}};
        end else begin
            c <= c + truncated_product;
        end
    end

    // Optional: Overflow detection (uncomment if needed)
    // wire overflow = (product > (2**(WIDTH-1)-1)) || (product < -(2**(WIDTH-1)));

endmodule