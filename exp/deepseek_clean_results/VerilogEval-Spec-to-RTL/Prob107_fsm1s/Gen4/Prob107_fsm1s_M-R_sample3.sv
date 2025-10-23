module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A
    wire next_state;

    // Combinational next-state logic
    assign next_state = (state == 0) ? (in ? 0 : 1) : (in ? 1 : 0);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 0;  // Reset to state B
        else
            state <= next_state;
    end

    // Output logic (Moore style)
    assign out = ~state;  // out=1 when state=B (0), out=0 when state=A (1)

endmodule