module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // Enumerated states for clarity
    typedef enum logic {
        LEFT,
        RIGHT
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        if (bump_left | bump_right)
            next_state = (state == LEFT) ? RIGHT : LEFT;
        else
            next_state = state;
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

    // Moore output logic
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule