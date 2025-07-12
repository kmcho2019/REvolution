module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0 for A, 1 for B
    wire next_state;

    // Combinational next state logic
    assign next_state = (state & in) | (~state & ~in);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore: output depends only on state)
    assign out = state;

endmodule