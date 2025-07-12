module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire gated_clk;
wire mux_out;

// Clock gating for power reduction
assign gated_clk = clk & (E | L);

// Combined mux and enable logic
assign mux_out = L ? R : (E ? w : Q);  // Maintains current state when disabled

// Single always block for cleaner implementation
always @(posedge gated_clk) begin
    Q <= mux_out;
end

endmodule