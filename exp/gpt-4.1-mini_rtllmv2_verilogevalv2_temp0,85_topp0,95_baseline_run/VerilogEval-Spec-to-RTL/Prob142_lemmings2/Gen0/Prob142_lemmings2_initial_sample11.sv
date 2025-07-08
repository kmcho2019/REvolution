module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding
    typedef enum reg [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;
    state_t prev_walk_state; // To remember direction before falling

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_state <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update prev_walk_state only when in walking states
            if (next_state == WALK_LEFT || next_state == WALK_RIGHT)
                prev_walk_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case(state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    // fall when ground disappears
                    next_state = FALLING;
                end else if (bump_left && bump_right) begin
                    // bumped both sides: switch direction
                    next_state = WALK_RIGHT;
                end else if (bump_left) begin
                    // bump left => walk right
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // bump right => walk left (already in walk_left, so hold)
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left && bump_right) begin
                    next_state = WALK_LEFT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                // Ignore bumps when falling
                if (ground == 1) begin
                    // ground returned, resume previous walking direction
                    next_state = prev_walk_state;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic: Moore outputs depend only on current state
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        case(state)
            WALK_LEFT: begin
                walk_left = 1;
            end
            WALK_RIGHT: begin
                walk_right = 1;
            end
            FALLING: begin
                aaah = 1;
            end
        endcase
    end

endmodule