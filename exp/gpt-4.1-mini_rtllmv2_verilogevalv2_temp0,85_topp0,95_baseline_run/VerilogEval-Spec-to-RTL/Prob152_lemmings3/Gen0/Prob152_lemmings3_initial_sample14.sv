module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

// State encoding
typedef enum logic [2:0] {
    WALK_LEFT    = 3'd0,
    WALK_RIGHT   = 3'd1,
    DIGGING_LEFT = 3'd2,
    DIGGING_RIGHT= 3'd3,
    FALLING_LEFT = 3'd4,
    FALLING_RIGHT= 3'd5
} state_t;

state_t state, next_state;

// Output logic (Moore)
assign walk_left  = (state == WALK_LEFT) || (state == DIGGING_LEFT);
assign walk_right = (state == WALK_RIGHT) || (state == DIGGING_RIGHT);
assign digging    = (state == DIGGING_LEFT) || (state == DIGGING_RIGHT);
assign aaah       = (state == FALLING_LEFT) || (state == FALLING_RIGHT);

// Determine if bumped (either side)
wire bumped = bump_left | bump_right;
wire bumped_both = bump_left & bump_right;

always @(*) begin
    // Default next state
    next_state = state;

    case(state)
        // Walking left
        WALK_LEFT: begin
            if (!ground) begin
                // Fall left
                next_state = FALLING_LEFT;
            end else if (dig) begin
                // Start digging left
                next_state = DIGGING_LEFT;
            end else if (bumped) begin
                // Switch direction to walk right
                next_state = WALK_RIGHT;
            end
        end

        // Walking right
        WALK_RIGHT: begin
            if (!ground) begin
                // Fall right
                next_state = FALLING_RIGHT;
            end else if (dig) begin
                // Start digging right
                next_state = DIGGING_RIGHT;
            end else if (bumped) begin
                // Switch direction to walk left
                next_state = WALK_LEFT;
            end
        end

        // Digging left
        DIGGING_LEFT: begin
            if (!ground) begin
                // Start falling left when ground disappears during digging
                next_state = FALLING_LEFT;
            end else begin
                // Keep digging left
                next_state = DIGGING_LEFT;
            end
            // bumps and dig ignored during digging
        end

        // Digging right
        DIGGING_RIGHT: begin
            if (!ground) begin
                // Start falling right when ground disappears during digging
                next_state = FALLING_RIGHT;
            end else begin
                // Keep digging right
                next_state = DIGGING_RIGHT;
            end
            // bumps and dig ignored during digging
        end

        // Falling left
        FALLING_LEFT: begin
            if (ground) begin
                // Ground reappeared, resume walking left
                next_state = WALK_LEFT;
            end else begin
                // Keep falling left
                next_state = FALLING_LEFT;
            end
            // bumps and dig ignored during falling
        end

        // Falling right
        FALLING_RIGHT: begin
            if (ground) begin
                // Ground reappeared, resume walking right
                next_state = WALK_RIGHT;
            end else begin
                // Keep falling right
                next_state = FALLING_RIGHT;
            end
            // bumps and dig ignored during falling
        end

        default: begin
            // Safety fallback: start walking left
            next_state = WALK_LEFT;
        end
    endcase
end

// Sequential logic with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

endmodule