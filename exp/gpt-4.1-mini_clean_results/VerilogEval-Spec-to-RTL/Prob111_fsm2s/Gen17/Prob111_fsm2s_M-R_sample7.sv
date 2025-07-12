module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg OFF_state, ON_state;
    wire OFF_next, ON_next;

    // Next state logic as combinational assignments
    assign OFF_next = (reset) ? 1'b1 : (ON_state & k) | (OFF_state & ~j);
    assign ON_next  = (reset) ? 1'b0 : (OFF_state & j) | (ON_state & ~k);

    // State update
    always @(posedge clk) begin
        OFF_state <= OFF_next;
        ON_state  <= ON_next;
    end

    // Output depends only on being in ON state (Moore)
    assign out = ON_state;

endmodule