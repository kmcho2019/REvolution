module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

// Improved next state logic using MUX-like structure:
// case 00: maintain state (Q_reg)
// case 01: reset (0)
// case 10: set (1)
// case 11: toggle (~Q_reg)
wire Q_next = (j & k) ? ~Q_reg : 
              (j | k) ? j : 
              Q_reg;

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule