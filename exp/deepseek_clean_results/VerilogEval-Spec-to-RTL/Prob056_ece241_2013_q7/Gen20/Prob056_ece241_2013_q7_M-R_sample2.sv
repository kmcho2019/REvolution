module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

wire D;

// Combinational logic for next state
assign D = (j & ~k) | (~j & ~k & Q) | (j & k & ~Q);

// Sequential element (D flip-flop)
reg Q_reg;
always @(posedge clk) begin
    Q_reg <= D;
end

assign Q = Q_reg;

endmodule