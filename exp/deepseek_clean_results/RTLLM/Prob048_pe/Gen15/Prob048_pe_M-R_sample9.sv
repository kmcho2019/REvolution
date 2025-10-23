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
    wire signed [2*WIDTH-1:0] product;
    assign product = a * b;

    // Combinational accumulator path
    wire signed [WIDTH-1:0] next_c;
    assign next_c = c + product[WIDTH-1:0];

    // Sequential accumulator register
    always @(posedge clk) begin
        if (rst) begin
            c <= {WIDTH{1'b0}};
        end else begin
            c <= next_c;
        end
    end

endmodule