module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding: two flip-flops represent two states
    // walk_left = 1 when state_left flip-flop is set
    // walk_right = 1 when state_right flip-flop is set

    reg state_left, state_right;
    reg next_state_left, next_state_right;

    // Asynchronous positive edge reset sets state_left = 1, state_right = 0 (walk_left)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_left  <= 1'b1;
            state_right <= 1'b0;
        end else begin
            state_left  <= next_state_left;
            state_right <= next_state_right;
        end
    end

    // Combinational next state logic:
    // - If either bump_left or bump_right is 1, switch states
    // - If no bump, stay in current state
    always @(*) begin
        if (bump_left | bump_right) begin
            // switch to the opposite state
            next_state_left  = state_right;
            next_state_right = state_left;
        end else begin
            // hold current state
            next_state_left  = state_left;
            next_state_right = state_right;
        end
    end

    // Outputs directly from one-hot state flip-flops
    assign walk_left  = state_left;
    assign walk_right = state_right;

endmodule