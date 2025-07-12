module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

wire next_Q;
reg Q_reg;

// Combinational logic: Efficient JK implementation
assign next_Q = (j ^ k) ? j : (j ^ Q_reg);

// Sequential element
always @(posedge clk) begin
    Q_reg <= next_Q;
end

assign Q = Q_reg;

endmodule