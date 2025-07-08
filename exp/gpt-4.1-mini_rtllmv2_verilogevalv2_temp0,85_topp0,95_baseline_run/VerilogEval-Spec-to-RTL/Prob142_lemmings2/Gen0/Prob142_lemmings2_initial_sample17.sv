module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // Preserve walking direction when falling
    // Use a register to remember direction: 0 = left, 1 = right
    reg walk_dir; // 0: left, 1: right

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state    <= WALK_LEFT;
            walk_dir <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update walk_dir only when walking states change
            if (next_state == WALK_LEFT)
                walk_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                walk_dir <= 1'b1;
            // If FALLING, walk_dir remains unchanged
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    // ground gone: start falling, preserve walk_dir
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // bumped: switch direction
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                if (ground) begin
                    // ground back: return to walking direction preserved in walk_dir
                    next_state = (walk_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Moore outputs
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        case (state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah       = 1'b1;
        endcase
    end

endmodule