module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding: state[0] = walk_left, state[1] = walk_right
    reg [1:0] state, next_state;

    // Asynchronous positive edge reset initializes to walk_left (state = 2'b01)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // walk_left
        else
            state <= next_state;
    end

    // Next state logic:
    // If any bump (left or right) is asserted, switch to opposite direction.
    // Else hold current state.
    always @(*) begin
        if (bump_left | bump_right) begin
            if (state[0])        // currently walking left
                next_state = 2'b10;  // switch to walk_right
            else                 // currently walking right
                next_state = 2'b01;  // switch to walk_left
        end else begin
            next_state = state;     // hold state if no bump
        end
    end

    // Outputs are directly mapped from one-hot state bits (Moore output)
    assign walk_left  = state[0];
    assign walk_right = state[1];

endmodule