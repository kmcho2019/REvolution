module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

wire next_Q;

// Combinational logic for JK flip-flop behavior
assign next_Q = (j & ~Q) | (~k & Q);

// Sequential element (D flip-flop)
reg Q_reg;
always @(posedge clk) begin
    Q_reg <= next_Q;
end

assign Q = Q_reg;

endmodule