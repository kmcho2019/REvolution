module pe #(
    parameter WIDTH = 32,
    parameter OVERFLOW_DETECTION = 0
) (
    input wire clk,
    input wire rst,
    input wire en,        // Enable signal for power reduction
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output wire signed [WIDTH-1:0] c,
    output wire overflow   // Optional overflow flag
);

    // Pipeline registers
    reg signed [2*WIDTH-1:0] product_reg;
    reg signed [2*WIDTH-1:0] acc_reg;

    // Stage 1: Multiplication
    wire signed [2*WIDTH-1:0] product = a * b;

    // Stage 2: Accumulation
    wire signed [2*WIDTH-1:0] next_acc = acc_reg + product_reg;

    // Overflow detection (optional)
    generate
        if (OVERFLOW_DETECTION) begin
            assign overflow = (next_acc > (2**(WIDTH-1)-1)) || 
                             (next_acc < -(2**(WIDTH-1)));
        end else begin
            assign overflow = 1'b0;
        end
    endgenerate

    // Output truncation
    assign c = acc_reg[WIDTH-1:0];

    // Pipeline control
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 0;
            acc_reg <= 0;
        end else if (en) begin
            product_reg <= product;
            acc_reg <= next_acc;
        end
    end

endmodule