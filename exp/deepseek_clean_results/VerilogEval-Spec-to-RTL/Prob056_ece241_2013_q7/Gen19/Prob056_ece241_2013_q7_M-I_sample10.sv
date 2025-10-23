module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
always @(posedge clk) begin
    case ({j, k})
        2'b00: Q_reg <= Q_reg;
        2'b01: Q_reg <= 1'b0;
        2'b10: Q_reg <= 1'b1;
        2'b11: Q_reg <= ~Q_reg;
    endcase
end

assign Q = Q_reg;

endmodule