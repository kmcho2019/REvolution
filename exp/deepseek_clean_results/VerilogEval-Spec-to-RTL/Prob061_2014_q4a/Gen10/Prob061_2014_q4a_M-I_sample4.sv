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

assign gated_clk = clk & (L | E);  // Clock gating when neither L nor E is active
assign mux_out = L ? R : (E ? w : Q);  // Single mux with priority

always @(posedge gated_clk) begin
    Q <= mux_out;
end

endmodule