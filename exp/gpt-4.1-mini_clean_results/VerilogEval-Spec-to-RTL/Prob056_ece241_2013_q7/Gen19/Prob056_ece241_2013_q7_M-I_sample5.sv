module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

// JK flip-flop characteristic behavior:
// Q_next = (J & ~Q) | (~K & Q)
//
// This logic is implemented directly in the sequential block,
// and Q updates only when the next state differs, to reduce switching.

always @(posedge clk) begin
    // Compute next state based on JK inputs and current Q
    // Matches JK truth table:
    // J K | Q_next
    // 0 0 | Q (hold)
    // 0 1 | 0 (reset)
    // 1 0 | 1 (set)
    // 1 1 | ~Q (toggle)
    reg Q_next;
    Q_next = (j & ~Q) | (~k & Q);

    // Update output only if next state differs (reduces toggling)
    if (Q_next != Q)
        Q <= Q_next;
    // else retain Q (no assignment to minimize switching)
end

endmodule