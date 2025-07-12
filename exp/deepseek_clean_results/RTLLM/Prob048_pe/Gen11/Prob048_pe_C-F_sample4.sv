module pe #(
    parameter WIDTH = 32,              // Configurable bit-width
    parameter USE_DSP = 1,            // Use DSP blocks if available
    parameter PIPELINE = 0             // Enable pipeline register
) (
    input wire clk,
    input wire rst,
    input wire en,                     // Enable signal for power reduction
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    // Full precision multiplication result
    wire signed [2*WIDTH-1:0] product;
    generate
        if (USE_DSP) begin
            assign product = a * b;    // Let synthesis tool infer DSP
        end else begin
            // Alternative implementation for area optimization
            assign product = {{WIDTH{a[WIDTH-1]}}, a} * {{WIDTH{b[WIDTH-1]}}, b};
        end
    endgenerate

    // Optional pipeline register
    reg signed [WIDTH-1:0] product_reg;
    wire signed [WIDTH-1:0] product_trunc = PIPELINE ? product_reg : product[WIDTH-1:0];

    always @(posedge clk) begin
        if (rst) begin
            c <= {WIDTH{1'b0}};
            if (PIPELINE) product_reg <= {WIDTH{1'b0}};
        end else if (en) begin
            if (PIPELINE) product_reg <= product[WIDTH-1:0];
            c <= c + product_trunc;   // Truncated accumulation
        end
    end

    // Documentation of truncation behavior
    // Note: Accumulation uses only lower WIDTH bits of product
    // For full precision, increase WIDTH parameter

endmodule