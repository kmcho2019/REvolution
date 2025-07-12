module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire clk_enable = L | E;
wire clk_gated = clk & clk_enable;

always @(posedge clk_gated) begin
    if (L)
        Q <= R;
    else // E must be active if we get here (due to clock gating)
        Q <= w;
end

endmodule