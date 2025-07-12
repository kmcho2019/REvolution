module TopModule #(
    parameter WIDTH = 100
) (
    input  clk,
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk) begin
        shift_reg <= {in[WIDTH-1], shift_reg[WIDTH-1:1]};
    end

    assign out = shift_reg;

endmodule