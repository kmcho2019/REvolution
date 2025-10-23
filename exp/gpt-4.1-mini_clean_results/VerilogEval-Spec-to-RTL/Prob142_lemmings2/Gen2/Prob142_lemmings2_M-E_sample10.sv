module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // Register to remember last walking direction during falling
    state_t last_walk_dir;

    // Next state logic combinational
    always @(*) begin
        // Default next state
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING; // start falling
                else if (bump_left && bump_right)
                    next_state = WALK_RIGHT; // flip direction
                else if (bump_left)
                    next_state = WALK_RIGHT; // bump left => walk right
                else if (bump_right)
                    next_state = WALK_LEFT;  // bump right => walk left (already walk left)
                else
                    next_state = WALK_LEFT;  // stay walking left
            end

            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING; // start falling
                else if (bump_left && bump_right)
                    next_state = WALK_LEFT; // flip direction
                else if (bump_left)
                    next_state = WALK_RIGHT; // bump left => walk right (already walk right)
                else if (bump_right)
                    next_state = WALK_LEFT;  // bump right => walk left
                else
                    next_state = WALK_RIGHT; // stay walking right
            end

            FALLING: begin
                if (ground) begin
                    // On ground return, resume previous walking direction
                    next_state = last_walk_dir;
                end else
                    next_state = FALLING; // remain falling
            end

            default: next_state = WALK_LEFT; // Should not happen
        endcase
    end

    // Sequential state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            last_walk_dir <= WALK_LEFT;
        end else begin
            state <= next_state;

            // Update last_walk_dir only on transitions from walking to falling
            if ((state == WALK_LEFT || state == WALK_RIGHT) && next_state == FALLING) begin
                last_walk_dir <= state;
            end
        end
    end

    // Output logic (Moore outputs)
    assign aaah = (state == FALLING);
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule