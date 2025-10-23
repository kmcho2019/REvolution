module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire d_input;

assign d_input = (j & ~Q_reg) | (~k & Q_reg);

always @(posedge clk) begin
    Q_reg <= d_input;
end

assign Q = Q_reg;

endmodule