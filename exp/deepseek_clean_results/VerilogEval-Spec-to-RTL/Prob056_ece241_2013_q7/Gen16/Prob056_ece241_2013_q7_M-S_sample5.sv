module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

always @(posedge clk) begin
    Q_reg <= (j ^ k) ? j : (j ^ Q_reg);
end

assign Q = Q_reg;

endmodule