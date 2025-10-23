module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    typedef enum logic {WALK_LEFT=1'b0, WALK_RIGHT=1'b1} state_t;
    state_t state, next_state;

    // Asynchronous positive edge reset, synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        if (bump_left || bump_right)
            next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
        else
            next_state = state;
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = (state == WALK_LEFT) ? 1'b1 : 1'b0;
        walk_right = (state == WALK_RIGHT) ? 1'b1 : 1'b0;
    end

endmodule