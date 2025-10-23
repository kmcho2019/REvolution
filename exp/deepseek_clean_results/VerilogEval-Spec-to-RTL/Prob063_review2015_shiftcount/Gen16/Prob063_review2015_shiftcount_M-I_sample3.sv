module TopModule #(
    parameter WIDTH = 4
) (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [WIDTH-1:0] q
);

wire clk_enable = shift_ena | count_ena;
wire gated_clk = clk & clk_enable;

always @(posedge gated_clk) begin
    if (shift_ena)
        q <= {q[WIDTH-2:0], data};    // Shift operation
    else // count_ena must be true (due to clock gating)
        q <= q - 1'b1;                // Count operation
end

endmodule