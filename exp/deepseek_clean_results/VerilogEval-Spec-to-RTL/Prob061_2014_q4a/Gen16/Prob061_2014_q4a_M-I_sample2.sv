module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire gated_clk = clk & (L | E);  // Clock gating when active

always @(posedge gated_clk) begin
    if (L) Q <= R;      // Highest priority: Load
    else if (E) Q <= w; // Shift when enabled
    // else hold - implicit in the gated clock
end

// Default hold behavior when clock is gated off
always @(negedge (L | E)) begin
    if (!(L | E)) Q <= Q;
end

endmodule