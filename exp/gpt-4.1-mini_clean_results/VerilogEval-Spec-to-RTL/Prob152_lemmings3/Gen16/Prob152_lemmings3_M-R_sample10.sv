module TopModule(
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

// Define combined states encoding mode and direction
typedef enum logic [2:0] {
    WALK_LEFT  = 3'd0,
    WALK_RIGHT = 3'd1,
    FALL_LEFT  = 3'd2,
    FALL_RIGHT = 3'd3,
    DIG_LEFT   = 3'd4,
    DIG_RIGHT  = 3'd5
} state_t;

state_t state, state_next;

always @(*) begin
    state_next = state; // default hold state

    case (state)
        WALK_LEFT: begin
            if (!ground) 
                state_next = FALL_LEFT;
            else if (dig)
                state_next = DIG_LEFT;
            else if (bump_left || bump_right) begin
                // Switch direction on any bump while walking
                if (bump_left && bump_right)
                    state_next = WALK_RIGHT;
                else if (bump_left)
                    state_next = WALK_RIGHT;
                else
                    state_next = WALK_LEFT; // bump_right causes switch left? No, switch left if bumped right
            end
        end
        WALK_RIGHT: begin
            if (!ground)
                state_next = FALL_RIGHT;
            else if (dig)
                state_next = DIG_RIGHT;
            else if (bump_left || bump_right) begin
                if (bump_left && bump_right)
                    state_next = WALK_LEFT;
                else if (bump_right)
                    state_next = WALK_LEFT;
                else
                    state_next = WALK_RIGHT;
            end
        end
        FALL_LEFT: begin
            if (ground)
                state_next = WALK_LEFT;
            // else remain falling left
        end
        FALL_RIGHT: begin
            if (ground)
                state_next = WALK_RIGHT;
            // else remain falling right
        end
        DIG_LEFT: begin
            if (!ground)
                state_next = FALL_LEFT;
            // else remain digging left
        end
        DIG_RIGHT: begin
            if (!ground)
                state_next = FALL_RIGHT;
            // else remain digging right
        end
        default: state_next = WALK_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= state_next;
end

assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule