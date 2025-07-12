module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire gated_clk;
wire hold = ~E & ~L;
wire next_Q = (L) ? R : ((E) ? w : Q);

// Clock gating cell (integrated in synthesis)
assign gated_clk = hold ? 1'b0 : clk;

always @(posedge gated_clk) begin
    Q <= next_Q;
end

endmodule