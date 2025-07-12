module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg  [31:0] acc;
    reg  [31:0] next_acc;

    wire [63:0] product;
    wire [32:0] sum_ext;
    wire        overflow;

    // Multiply inputs combinationally
    assign product = a * b;

    // Extend accumulator and sum with lower 32 bits of product
    assign sum_ext = {1'b0, acc} + product[31:0];

    // Detect overflow
    assign overflow = sum_ext[32];

    // Combinational logic for next accumulator value with saturation
    always @* begin
        if (overflow)
            next_acc = 32'hFFFF_FFFF; // Saturate at max unsigned 32-bit
        else
            next_acc = sum_ext[31:0];
    end

    // Sequential logic for accumulator register with synchronous reset
    always @(posedge clk) begin
        if (rst)
            acc <= 32'd0;
        else
            acc <= next_acc;
    end

    // Output the accumulator value
    assign c = acc;

endmodule