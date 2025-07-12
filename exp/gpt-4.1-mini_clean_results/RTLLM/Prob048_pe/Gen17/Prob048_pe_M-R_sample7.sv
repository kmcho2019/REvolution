module pe (
    input           clk,
    input           rst,        // synchronous reset, active high
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    // Compute product as continuous assignment
    wire [63:0] product = a * b;

    // Extended sum for overflow detection
    wire [32:0] sum_ext = {1'b0, c} + product[31:0];
    wire overflow = sum_ext[32];

    // Next accumulator value (combinational)
    wire [31:0] next_c = overflow ? 32'hFFFF_FFFF : sum_ext[31:0];

    // Accumulator register update
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= next_c;
        end
    end

endmodule