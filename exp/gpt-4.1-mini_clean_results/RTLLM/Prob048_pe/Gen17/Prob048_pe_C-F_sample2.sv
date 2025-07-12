module pe (
    input           clk,
    input           rst,    // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [31:0] acc;
    wire [63:0] product;
    wire [32:0] sum_ext;
    wire overflow;

    // Perform 32x32 unsigned multiplication
    assign product = a * b;

    // Extend acc and add lower 32 bits of product to detect overflow
    assign sum_ext = {1'b0, acc} + product[31:0];

    // Overflow detected if the 33rd bit is set
    assign overflow = sum_ext[32];

    // Sequential logic: accumulator update with saturation and synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
        end else begin
            if (overflow)
                acc <= 32'hFFFF_FFFF; // Saturate to max 32-bit unsigned
            else
                acc <= sum_ext[31:0];
        end
    end

    // Output directly driven from accumulator register to save area and power
    assign c = acc;

endmodule