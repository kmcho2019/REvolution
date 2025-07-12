module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

// Improved next state logic:
// - j & ~k: set (1)
// - ~j & k: reset (0)
// - j & k: toggle (~Q)
// - ~j & ~k: maintain (Q)
wire set = j & ~k;
wire reset = ~j & k;
wire toggle = j & k;
wire maintain = ~j & ~k;

wire Q_next = (set) ? 1'b1 :
              (reset) ? 1'b0 :
              (toggle) ? ~Q_reg :
              Q_reg;

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule