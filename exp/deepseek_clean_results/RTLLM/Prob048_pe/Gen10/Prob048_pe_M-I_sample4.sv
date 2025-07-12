module pe #(
    parameter WIDTH = 32,
    parameter OVERFLOW_DETECT = 0
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c,
    output wire overflow
);

    // Clock gating signals
    wire mult_enable = |a || |b;
    wire gated_clk = clk & mult_enable;

    // Pipeline stage 1: Multiplication
    reg signed [WIDTH-1:0] product_reg;
    wire signed [WIDTH-1:0] product = a * b;

    // Pipeline stage 2: Accumulation
    reg signed [WIDTH-1:0] c_next;
    wire signed [WIDTH-1:0] sum = c + product_reg;

    // Overflow detection (optional)
    generate
        if (OVERFLOW_DETECT) begin
            assign overflow = (sum[WIDTH-1] != c[WIDTH-1]) && 
                            (sum[WIDTH-1] != product_reg[WIDTH-1]);
        end else begin
            assign overflow = 1'b0;
        end
    endgenerate

    // Pipeline registers
    always @(posedge gated_clk or posedge rst) begin
        if (rst) begin
            product_reg <= {WIDTH{1'b0}};
            c <= {WIDTH{1'b0}};
        end else begin
            product_reg <= product;
            c <= sum;
        end
    end

endmodule