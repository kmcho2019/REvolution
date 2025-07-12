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

    assign product = a * b;
    assign sum_ext = {1'b0, acc} + product[31:0];
    assign overflow = sum_ext[32];

    always @(posedge clk) begin
        if (rst)
            acc <= 32'd0;
        else if (overflow)
            acc <= 32'hFFFF_FFFF; // Saturate at max 32-bit unsigned
        else
            acc <= sum_ext[31:0];
    end

    assign c = acc;

endmodule