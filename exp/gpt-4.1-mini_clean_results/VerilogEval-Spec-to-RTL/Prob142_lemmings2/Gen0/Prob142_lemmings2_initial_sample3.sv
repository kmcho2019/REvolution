module TopModule (
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
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALLING    = 2'd2
    } state_t;

    state_t state, next_state;
    state_t last_walk_dir; // Stores last walking direction before falling

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            last_walk_dir <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update last_walk_dir only when walking
            if (next_state == WALK_LEFT || next_state == WALK_RIGHT)
                last_walk_dir <= next_state;
        end
    end

    // Next state logic
    always @* begin
        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    // Start falling, remember last walking direction
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Switch direction when bumped
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    // Start falling, remember last walking direction
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Switch direction when bumped
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                if (ground == 1'b1) begin
                    // Land, resume walking in last walking direction
                    next_state = last_walk_dir;
                end else begin
                    // Continue falling
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT; // Safety default
        endcase
    end

    // Output logic (Moore outputs)
    always @* begin
        walk_left  = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
        aaah       = (state == FALLING);
    end

endmodule