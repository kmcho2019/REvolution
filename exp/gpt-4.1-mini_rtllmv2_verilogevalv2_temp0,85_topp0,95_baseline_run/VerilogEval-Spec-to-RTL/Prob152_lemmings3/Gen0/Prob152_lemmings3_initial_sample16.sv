module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    typedef enum logic [1:0] {
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALLING    = 2'd2,
        DIGGING    = 2'd3
    } state_t;

    state_t state, next_state;

    // To remember walking direction before falling
    // 0 = walk_left, 1 = walk_right
    reg walk_dir_before_fall;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_dir_before_fall <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update walk_dir_before_fall on walking states
            if (next_state == WALK_LEFT)
                walk_dir_before_fall <= 1'b0;
            else if (next_state == WALK_RIGHT)
                walk_dir_before_fall <= 1'b1;
            // no change in FALLING or DIGGING
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground) // fall has highest priority
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_left || bump_right) begin
                    // switch direction
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            DIGGING: begin
                // while digging, bumps and dig ignored
                if (!ground) 
                    next_state = FALLING;
                else
                    next_state = DIGGING;
            end

            FALLING: begin
                // while falling, bumps and dig ignored
                if (ground) begin
                    // go back to previous walking direction
                    if (walk_dir_before_fall == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Moore output logic based on state
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case(state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah       = 1'b1;
            DIGGING:    digging    = 1'b1;
        endcase
    end

endmodule