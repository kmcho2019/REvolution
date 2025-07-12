// Parameterized Shift Register Module
module TopModule #(
    parameter WIDTH = 4
)(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [WIDTH-1:0] shift_reg;

always @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= {WIDTH{1'b0}};
    end else begin
        shift_reg <= {in, shift_reg[WIDTH-1:1]};
    end
end

assign out = shift_reg[0];

endmodule