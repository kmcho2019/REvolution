module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

// Optimized next state logic:
// (j ^ k) handles set/reset cases (when j != k)
// (j & k) handles toggle case (when j == k == 1)
// otherwise maintains state (when j == k == 0)
wire Q_next = (j ^ k) ? j : (j & k) ^ Q_reg;

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule