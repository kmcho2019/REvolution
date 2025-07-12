module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot state encoding
    parameter S_WALK_LEFT  = 6'b000001;
    parameter S_WALK_RIGHT = 6'b000010;
    parameter S_FALL_LEFT  = 6'b000100;
    parameter S_FALL_RIGHT = 6'b001000;
    parameter S_DIG_LEFT   = 6'b010000;
    parameter S_DIG_RIGHT  = 6'b100000;

    reg [5:0] state, next_state;

    // State transition logic
    always @(*) begin
        next_state = state; // Default: stay in current state
        
        case (1'b1) // Synthesis will optimize this
            state[S_WALK_LEFT]: begin
                if (!ground)        next_state = S_FALL_LEFT;
                else if (dig)        next_state = S_DIG_LEFT;
                else if (bump_left)  next_state = S_WALK_RIGHT;
            end
            state[S_WALK_RIGHT]: begin
                if (!ground)        next_state = S_FALL_RIGHT;
                else if (dig)      next_state = S_DIG_RIGHT;
                else if (bump_right) next_state = S_WALK_LEFT;
            end
            state[S_FALL_LEFT]:  if (ground) next_state = S_WALK_LEFT;
            state[S_FALL_RIGHT]: if (ground) next_state = S_WALK_RIGHT;
            state[S_DIG_LEFT]:    if (!ground) next_state = S_FALL_LEFT;
            state[S_DIG_RIGHT]:   if (!ground) next_state = S_FALL_RIGHT;
        endcase
    end

    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) state <= S_WALK_LEFT;
        else state <= next_state;
    end

    // Output assignments directly from state bits
    assign walk_left  = state[S_WALK_LEFT];
    assign walk_right = state[S_WALK_RIGHT];
    assign aaah       = state[S_FALL_LEFT] | state[S_FALL_RIGHT];
    assign digging    = state[S_DIG_LEFT] | state[S_DIG_RIGHT];

endmodule