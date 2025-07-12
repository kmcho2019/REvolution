module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire Q_next;

assign Q_next = (j & ~k)        // Set when J=1,K=0
              | (~k & Q_reg)    // Hold when J=0,K=0
              | (j & ~Q_reg);   // Toggle when J=1,K=1 (combined with set case)

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule