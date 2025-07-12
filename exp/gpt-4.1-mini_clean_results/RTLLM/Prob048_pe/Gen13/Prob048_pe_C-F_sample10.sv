module pe (
    input           clk,
    input           rst,        // synchronous reset, active high
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    wire [63:0] product = a * b;
    wire [32:0] sum_ext = {1'b0, c} + product[31:0]; // add lower 32 bits of product to accumulator with carry
    wire overflow = sum_ext[32];

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            if (overflow)
                c <= 32'hFFFF_FFFF; // saturate on overflow
            else
                c <= sum_ext[31:0];
        end
    end

endmodule