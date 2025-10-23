module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot state representation
    reg off_state, on_state;
    wire next_off, next_on;

    // Next state logic as combinational assigns
    assign next_off = reset | (on_state & k) | (off_state & ~j);
    assign next_on  = (off_state & j) | (on_state & ~k & ~reset);

    // State registers with synchronous reset
    always @(posedge clk) begin
        off_state <= next_off;
        on_state  <= next_on;
    end

    // Output from ON state (Moore)
    assign out = on_state;

endmodule