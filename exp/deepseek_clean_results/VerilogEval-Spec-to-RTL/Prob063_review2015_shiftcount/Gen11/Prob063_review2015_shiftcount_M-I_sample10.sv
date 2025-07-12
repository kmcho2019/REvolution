module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;
wire gated_clk;

CLKGATE clk_gate (
    .CK(clk),
    .E(clk_enable),
    .ECK(gated_clk)
);

always @(posedge gated_clk) begin
    if (shift_ena)
        q <= {q[2:0], data};  // Shift operation
    else if (count_ena)
        q <= q - 1'b1;        // Count operation
    // else hold (implicit)
end

endmodule