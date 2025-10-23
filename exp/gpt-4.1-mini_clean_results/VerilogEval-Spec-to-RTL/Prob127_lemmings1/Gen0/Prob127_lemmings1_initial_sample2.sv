module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Asynchronous positive edge reset, state register with synchronous update on clk posedge
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic - Moore FSM
    always @(*) begin
        // default to hold current state
        next_state = state;

        // if bump on left or right (or both), change direction
        if (bump_left || bump_right) begin
            next_state = ~state;
        end
    end

    // Output logic - Moore FSM outputs depend only on current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule