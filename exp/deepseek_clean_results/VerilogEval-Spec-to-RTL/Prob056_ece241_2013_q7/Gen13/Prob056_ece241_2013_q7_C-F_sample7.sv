module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

// Optimized next state logic:
// - When j != k: output follows j (set/reset)
// - When j == k == 1: toggle
// - When j == k == 0: maintain state
wire Q_next = (j ^ k) ? j : (j & k) ^ Q_reg;

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule