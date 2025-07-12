module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

always @(posedge clk) begin
    Q_reg <= (j & k) ? ~Q_reg :  // Toggle when both are 1
              (j & ~k) ? 1'b1 :  // Set when J=1, K=0
              (~j & k) ? 1'b0 :   // Reset when J=0, K=1
              Q_reg;              // Hold otherwise
end

assign Q = Q_reg;

endmodule