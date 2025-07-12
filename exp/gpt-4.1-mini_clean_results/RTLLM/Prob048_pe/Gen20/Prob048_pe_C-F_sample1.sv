module pe (
    input           clk,
    input           rst,    // synchronous reset, active high
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg  [31:0] acc;
    reg  [31:0] next_acc;

    wire [63:0] product;
    wire [32:0] sum_ext;
    wire        overflow;

    // Compute full 64-bit product combinationally
    assign product = a * b;

    // Sum accumulator with lower 32 bits of product
    assign sum_ext = {1'b0, acc} + {1'b0, product[31:0]};

    // Detect overflow (carry out of 32-bit addition)
    assign overflow = sum_ext[32];

    // Combinational saturation logic for next accumulator value
    always @* begin
        if (overflow)
            next_acc = 32'hFFFF_FFFF;
        else
            next_acc = sum_ext[31:0];
    end

    // Sequential accumulator update with synchronous reset
    always @(posedge clk) begin
        if (rst)
            acc <= 32'd0;
        else
            acc <= next_acc;
    end

    // Output assigned directly from accumulator register
    assign c = acc;

endmodule