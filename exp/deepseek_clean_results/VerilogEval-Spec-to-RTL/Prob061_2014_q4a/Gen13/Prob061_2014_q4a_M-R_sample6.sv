module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg Q_reg;
wire next_Q = L ? R : (E ? w : Q_reg);

always @(posedge clk) begin
    Q_reg <= next_Q;
end

assign Q = Q_reg;

endmodule