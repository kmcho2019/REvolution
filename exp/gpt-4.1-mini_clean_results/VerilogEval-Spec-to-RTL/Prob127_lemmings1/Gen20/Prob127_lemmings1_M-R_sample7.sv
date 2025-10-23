module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // Define states using typedef for clarity and potential scalability
    typedef enum logic [0:0] {WALK_LEFT = 1'b0, WALK_RIGHT = 1'b1} state_t;
    state_t state, next_state;

    // Next state logic as continuous assignment using Boolean expression
    // Using logic to toggle or hold according to bumps
    assign next_state = (bump_left & ~bump_right)             ? WALK_RIGHT :
                        (~bump_left & bump_right)             ? WALK_LEFT  :
                        (bump_left & bump_right)              ? ~state     :
                        state;

    // State register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore outputs directly from current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule