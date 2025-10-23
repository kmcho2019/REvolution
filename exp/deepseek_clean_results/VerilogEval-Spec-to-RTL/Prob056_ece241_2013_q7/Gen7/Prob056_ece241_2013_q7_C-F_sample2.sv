module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

// Optimized next-state logic with minimal gates
wire Q_next = (j ^ k) ? (j ? 1'b1 : 1'b0) : (j ? ~Q : Q);

reg Q_reg;
always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule