module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

// Improved next state logic with direct truth table implementation
wire Q_next = (j & ~k) |               // Set condition (J=1, K=0)
               (~j & k) ? 0 :          // Reset condition (J=0, K=1)
               (j & k) ? ~Q_reg :      // Toggle condition (J=1, K=1)
               Q_reg;                  // Hold condition (J=0, K=0)

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule