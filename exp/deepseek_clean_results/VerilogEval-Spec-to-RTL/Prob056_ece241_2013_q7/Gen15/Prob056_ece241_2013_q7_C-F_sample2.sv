module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

// Next state logic covering all cases:
// 1. When J≠K: output follows J (set/reset)
// 2. When J=K=1: toggle (XOR with current state)
// 3. When J=K=0: maintain current state
wire Q_next = (j ^ k) ? j : (j & k) ? ~Q_reg : Q_reg;

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule