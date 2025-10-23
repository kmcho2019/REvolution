module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

// Initialize Q to 0 at simulation start for defined startup behavior.
// This helps in simulation and formal verification without affecting synthesis.
initial begin
    Q = 0;
end

// JK flip-flop behavior implemented on positive clock edge using the characteristic equation:
// Q_next = (J & ~Q) | (~K & Q)
// Truth table:
// J K | Q_next
// 0 0 | Q     (hold)
// 0 1 | 0     (reset)
// 1 0 | 1     (set)
// 1 1 | ~Q    (toggle)
always @(posedge clk) begin
    Q <= (j & ~Q) | (~k & Q);
end

endmodule