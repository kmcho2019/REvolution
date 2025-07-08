module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
    );

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;
    state_t walk_state_before_fall; // to remember walking direction before falling

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // switch direction if bumped on either side
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // switch direction if bumped on either side
                    next_state = WALK_LEFT;
                end
            end

            FALLING: begin
                if (ground == 1) begin
                    // return to previous walking direction
                    next_state = walk_state_before_fall;
                end
                // bumps don't affect walking direction while falling
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // State register and remember walking direction before falling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_state_before_fall <= WALK_LEFT;
        end else begin
            if (state != FALLING && next_state == FALLING) begin
                // store current walking direction when entering FALLING
                walk_state_before_fall <= state;
            end
            state <= next_state;
        end
    end

    // Outputs (Moore machine - outputs depend only on current state)
    always @(*) begin
        // defaults
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALLING: begin
                aaah = 1'b1;
            end
        endcase
    end

endmodule