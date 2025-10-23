module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    // Combinational multiplier
    wire signed [2*WIDTH-1:0] full_product;
    assign full_product = a * b;

    // Truncated product (32 LSBs)
    wire signed [WIDTH-1:0] truncated_product;
    assign truncated_product = full_product[WIDTH-1:0];

    // Next accumulator value
    wire signed [WIDTH-1:0] next_c;
    assign next_c = c + truncated_product;

    // Sequential accumulator
    always @(posedge clk) begin
        if (rst) begin
            c <= {WIDTH{1'b0}};
        end else begin
            c <= next_c;
        end
    end

endmodule