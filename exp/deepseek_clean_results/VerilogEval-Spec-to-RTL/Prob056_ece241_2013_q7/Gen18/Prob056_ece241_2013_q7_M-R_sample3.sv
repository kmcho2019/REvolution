module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire Q_next;

// Combinational next-state logic
assign Q_next = (j == k) ? (j ^ Q_reg) : j;

// Sequential element
always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule