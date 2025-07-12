module pe (
    input               clk,
    input               rst,
    input               ce,         // clock enable for power optimization
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  c
);

    // Intermediate 64-bit product
    wire [63:0] product = a * b;

    // 32-bit accumulator with saturation
    reg [31:0] accumulator;

    // Saturation logic signals
    wire [31:0] sum_low = accumulator + product[31:0];
    wire overflow = (sum_low < accumulator);

    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 32'd0;
            c <= 32'd0;
        end else if (ce) begin
            // Accumulate with saturation on overflow
            if (overflow)
                accumulator <= 32'hFFFF_FFFF; // Saturate at max 32-bit unsigned
            else
                accumulator <= sum_low;
            c <= accumulator;
        end else begin
            // If clock enable is low, keep accumulator and output stable
            c <= accumulator;
        end
    end

endmodule