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

    // To remember walking direction before falling
    reg walking_dir; // 0 for left, 1 for right

    // Async reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_dir <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update walking_dir only if in walking states, preserve during FALLING
            if (next_state == WALK_LEFT)
                walking_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                walking_dir <= 1'b1;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Fall
                    next_state = FALLING;
                end else begin
                    // If bumped on left or right, switch direction
                    if (bump_left || bump_right) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    // Fall
                    next_state = FALLING;
                end else begin
                    if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
            FALLING: begin
                if (ground) begin
                    // Ground reappeared, go back to previous walking direction
                    if (walking_dir == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    // Stay falling
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        case(state)
            WALK_LEFT:  walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah = 1'b1;
        endcase
    end

endmodule