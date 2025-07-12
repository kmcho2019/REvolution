module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
always @(posedge clk) begin
    Q_reg <= j ? (k ? ~Q_reg : 1'b1) : 
              (k ? 1'b0 : Q_reg);
end

assign Q = Q_reg;

endmodule