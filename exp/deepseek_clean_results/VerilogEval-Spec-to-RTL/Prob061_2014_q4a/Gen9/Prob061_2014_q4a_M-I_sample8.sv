module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire gated_clk = clk & (L | E);

always @(posedge gated_clk) begin
    if (L)
        Q <= R;
    else // E must be active if gated_clk is toggling
        Q <= w;
end

endmodule