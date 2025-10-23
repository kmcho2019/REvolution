module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    // Compute next state of Q based on JK flip-flop characteristic equation
    // Update Q only if next state differs from current Q to avoid redundant toggles
    // This preserves behavior and reduces unnecessary switching activity.
    // Q_next = (j & ~Q) | (~k & Q);
    // Condition avoids Q <= Q assignment.
    reg next_Q;
    next_Q = (j & ~Q) | (~k & Q);
    if (next_Q != Q)
        Q <= next_Q;
end

endmodule