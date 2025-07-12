module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

// JK flip-flop characteristic:
// J K | Q_next
// 0 0 | Q (hold)
// 0 1 | 0 (reset)
// 1 0 | 1 (set)
// 1 1 | ~Q (toggle)
//
// Minimal characteristic equation:
// Q_next = (J & ~Q) | (~K & Q)

reg Q_next;

always @(*) begin
    Q_next = (j & ~Q) | (~k & Q);
end

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule