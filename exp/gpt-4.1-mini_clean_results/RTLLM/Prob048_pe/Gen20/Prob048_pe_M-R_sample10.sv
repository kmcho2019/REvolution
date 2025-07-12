module pe (
    input          clk,
    input          rst,    // synchronous active-high reset
    input  [31:0]  a,
    input  [31:0]  b,
    output reg [31:0] c
);

    reg [63:0] product_reg;
    wire [32:0] sum_ext;
    wire overflow;

    // Register the product on every clock edge to pipeline multiplier output
    always @(posedge clk) begin
        if (rst)
            product_reg <= 64'd0;
        else
            product_reg <= a * b;
    end

    // Compute sum and detect overflow combinationally
    assign sum_ext = {1'b0, c} + product_reg[31:0];
    assign overflow = sum_ext[32];

    // Accumulate with saturation on clock edge
    always @(posedge clk) begin
        if (rst)
            c <= 32'd0;
        else if (overflow)
            c <= 32'hFFFF_FFFF; // saturate at max 32-bit unsigned value
        else
            c <= sum_ext[31:0];
    end

endmodule