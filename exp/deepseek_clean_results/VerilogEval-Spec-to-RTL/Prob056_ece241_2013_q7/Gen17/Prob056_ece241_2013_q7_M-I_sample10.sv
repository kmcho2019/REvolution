module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

// Improved next state logic:
// Case 1: J != K -> output follows J (set/reset)
// Case 2: J == K == 1 -> toggle
// Case 3: J == K == 0 -> maintain state
wire Q_next = (j & ~k) |              // Set case (J=1,K=0)
               (~j & k) ? j :          // Reset case (J=0,K=1)
               (j & k) ? ~Q_reg :      // Toggle case (J=K=1)
               Q_reg;                 // Maintain case (J=K=0)

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule