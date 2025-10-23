module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire Q_next;

// Optimized combinational logic:
// - When J≠K: output follows J
// - When J=K=1: toggle
// - When J=K=0: maintain state
assign Q_next = (j ^ k) ? j : (j & k) ? ~Q_reg : Q_reg;

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule