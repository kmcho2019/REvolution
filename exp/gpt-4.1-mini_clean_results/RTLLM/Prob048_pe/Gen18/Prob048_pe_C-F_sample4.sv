module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg  [31:0] acc;
    wire [63:0] product;
    wire [32:0] sum_ext;
    wire        overflow;

    // Compute full 64-bit product combinationally
    assign product = a * b;

    // Extend accumulator and add lower 32 bits of product
    assign sum_ext = {1'b0, acc} + product[31:0];

    // Detect overflow if carry-out from addition is set
    assign overflow = sum_ext[32];

    // Sequential logic: synchronous reset, accumulate or saturate on overflow
    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
        end else begin
            if (overflow)
                acc <= 32'hFFFF_FFFF; // Saturate at max unsigned 32-bit value
            else
                acc <= sum_ext[31:0];
        end
    end

    // Output accumulator value
    assign c = acc;

endmodule