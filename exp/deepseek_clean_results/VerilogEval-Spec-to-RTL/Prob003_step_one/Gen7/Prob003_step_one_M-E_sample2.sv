module TopModule (
    output reg one
);

    // Single-state state machine
    localparam STATE_ONE = 1'b1;
    reg state = STATE_ONE;

    always @(*) begin
        state = STATE_ONE;  // Always stay in state one
        one = state;        // Output reflects current state
    end

endmodule