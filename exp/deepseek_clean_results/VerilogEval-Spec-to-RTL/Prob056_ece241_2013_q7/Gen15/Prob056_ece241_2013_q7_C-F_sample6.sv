module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

// Optimized next state logic covering all cases:
// 1. j=0,k=0: Q_reg remains (handled by ~k & Q_reg term)
// 2. j=0,k=1: 0 (handled by ~k term being 0)
// 3. j=1,k=0: 1 (handled by j & ~k term)
// 4. j=1,k=1: ~Q_reg (handled by j & Q_reg term when k=1)
wire Q_next = (j & ~k) | (~k & Q_reg) | (j & Q_reg);

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule