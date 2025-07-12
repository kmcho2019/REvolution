module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire gated_clk;
wire next_Q;

// Clock gating logic
assign gated_clk = clk & (L | E);

// Next state logic using explicit mux
assign next_Q = L ? R : (E ? w : Q);

// Gated clock flip-flop
always @(posedge gated_clk) begin
    Q <= next_Q;
end

endmodule