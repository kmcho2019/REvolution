module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Equivalent JK flip-flop next state with balanced boolean expression
wire Q_next = j ^ (Q & ~(j & k));

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule