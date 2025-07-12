module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire Q_next;

// Combinational logic for JK flip-flop behavior
assign Q_next = (j & ~k) | (~j & ~k & Q) | (j & k & ~Q);

// Sequential element (D flip-flop)
always @(posedge clk) begin
    Q <= Q_next;
end

endmodule