module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    wire [63:0] product = a * b;
    wire [32:0] sum_ext = {1'b0, c} + product[31:0];
    wire overflow = sum_ext[32];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            if (overflow)
                c <= 32'hFFFF_FFFF; // saturate at max 32-bit value
            else
                c <= sum_ext[31:0];
        end
    end

endmodule