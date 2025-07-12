module TopModule(
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
    state_t stored_walk_dir; // Used to remember walking direction during fall

    // Async reset and state register
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            stored_walk_dir <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update stored_walk_dir only when walking (not falling)
            if (next_state != FALLING) begin
                stored_walk_dir <= next_state;
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // switch direction if bumped on either side
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Resume walking in stored direction
                    next_state = stored_walk_dir;
                end
                // Else remain in FALLING ignoring bumps
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore outputs)
    always_comb begin
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