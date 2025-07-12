module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire clk_gated = clk & (E | L);  // Clock gating when active

always @(posedge clk_gated) begin
    if (L)
        Q <= R;
    else if (E)
        Q <= w;
    // Else retain state (implicit)
end

endmodule