module pe (
    input           clk,
    input           rst,        // synchronous reset, active high
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    reg [63:0] product_reg;

    // Stage 1: Register the product
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= a * b;
        end
    end

    // Stage 2: Accumulate product_reg[31:0] into c with saturation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            // Perform extended addition to detect overflow
            // Using lower 32 bits of the product as in original spec
            {wire overflow, c} = {1'b0, c} + product_reg[31:0];

            if (overflow)
                c <= 32'hFFFF_FFFF; // saturate on overflow
            else
                c <= c + product_reg[31:0];
        end
    end

endmodule