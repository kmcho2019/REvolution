module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire next_Q;

// Combinational next state logic
assign next_Q = (j & k) ? ~Q_reg :  // Toggle when both are 1
                (j & ~k) ? 1'b1 :   // Set when J=1, K=0
                (~j & k) ? 1'b0 :   // Reset when J=0, K=1
                Q_reg;              // Hold otherwise

// Sequential element (D flip-flop)
always @(posedge clk) begin
    Q_reg <= next_Q;
end

assign Q = Q_reg;

endmodule