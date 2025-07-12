module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

// Minimal combinational logic implementing JK characteristic equation:
// Q_next = (J & ~Q) | (~K & Q)
// Corresponding to JK truth table:
// J K | Q_next
// 0 0 | Q (hold)
// 0 1 | 0 (reset)
// 1 0 | 1 (set)
// 1 1 | ~Q (toggle)
wire Q_next;

assign Q_next = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule