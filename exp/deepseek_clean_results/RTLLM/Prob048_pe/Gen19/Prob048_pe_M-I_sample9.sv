module pe #(
    parameter WIDTH = 32,
    parameter OVERFLOW_DETECT = 0
) (
    input wire clk,
    input wire rst,
    input wire en,         // Enable signal for power reduction
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c,
    output wire overflow   // Optional overflow flag
);

    // Pipeline registers
    reg signed [WIDTH-1:0] a_reg, b_reg;
    reg signed [WIDTH-1:0] product_reg;
    reg signed [WIDTH-1:0] accum_reg;

    // Stage 1: Register inputs and compute product (with immediate truncation)
    wire signed [WIDTH-1:0] product = a * b;

    // Stage 2: Accumulation
    wire signed [WIDTH-1:0] next_accum = accum_reg + product_reg;

    // Overflow detection (optional)
    generate
        if (OVERFLOW_DETECT) begin
            assign overflow = (next_accum < accum_reg && product_reg > 0) || 
                            (next_accum > accum_reg && product_reg < 0);
        end else begin
            assign overflow = 1'b0;
        end
    endgenerate

    // Pipeline control
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            product_reg <= 0;
            accum_reg <= 0;
            c <= 0;
        end else if (en) begin
            // Stage 1
            a_reg <= a;
            b_reg <= b;
            product_reg <= product;
            
            // Stage 2
            accum_reg <= next_accum;
            c <= next_accum;
        end
    end

endmodule