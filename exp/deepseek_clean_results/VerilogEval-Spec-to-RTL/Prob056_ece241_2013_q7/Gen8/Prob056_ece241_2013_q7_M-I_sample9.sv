module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

wire Q_next = (j & ~k) |          // J=1,K=0 case
              (~j & k & ~Q) |    // J=0,K=1 case
              (j & k & ~Q);      // J=1,K=1 case

reg Q_reg;
always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule