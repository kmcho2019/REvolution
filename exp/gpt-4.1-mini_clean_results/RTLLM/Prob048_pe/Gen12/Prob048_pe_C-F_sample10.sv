module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [31:0] acc;
    wire [63:0] product;
    wire [32:0] sum_ext;
    wire overflow;

    // Combinational product
    assign product = a * b;

    // Extended sum for overflow detection
    assign sum_ext = {1'b0, acc} + product[31:0];

    // Overflow occurs if MSB of sum_ext is set
    assign overflow = sum_ext[32];

    // Sequential accumulation with synchronous reset and saturation on overflow
    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
        end else begin
            if (overflow)
                acc <= 32'hFFFF_FFFF; // Saturate max 32-bit value
            else
                acc <= sum_ext[31:0];
        end
    end

    // Continuous assignment of accumulator to output
    assign c = acc;

endmodule