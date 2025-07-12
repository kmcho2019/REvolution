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

    // Combinational product calculation (32x32 multiplication)
    assign product = a * b;

    // Extend accumulator to 33 bits to detect overflow on addition
    assign sum_ext = {1'b0, acc} + product[31:0];

    // Overflow if carry-out bit is set
    assign overflow = sum_ext[32];

    // Sequential accumulation with synchronous reset and saturation
    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
        end else begin
            if (overflow)
                acc <= 32'hFFFF_FFFF; // Saturate at max 32-bit unsigned value
            else
                acc <= sum_ext[31:0];
        end
    end

    // Continuous output assignment from accumulator register
    assign c = acc;

endmodule