module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state registers: only one bit high at a time
    reg B_state, A_state;

    // Next state signals (combinational)
    wire B_next, A_next;

    // Synchronous state update with active-high synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            B_state <= 1'b1;  // Reset to state B
            A_state <= 1'b0;
        end else begin
            B_state <= B_next;
            A_state <= A_next;
        end
    end

    // Next state combinational logic based on current state and input
    assign B_next = (B_state & in) | (A_state & ~in);
    assign A_next = (B_state & ~in) | (A_state & in);

    // Moore output: output = 1 when in state B, 0 when in A
    assign out = B_state;

endmodule