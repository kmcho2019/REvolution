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

    typedef enum reg [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    // Register to remember direction during FALLING (0=left,1=right)
    reg dir, next_dir;

    // State and direction update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            dir <= 1'b0;  // left
        end else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    // Next state logic
    always @* begin
        // Defaults: hold current state and direction
        next_state = state;
        next_dir = dir;

        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    // Falling, remember direction = left
                    next_state = FALLING;
                    next_dir = 1'b0;
                end else if (bump_left || bump_right) begin
                    // On bump, switch direction to right
                    next_state = WALK_RIGHT;
                    next_dir = 1'b1;
                end else begin
                    // Remain walking left
                    next_state = WALK_LEFT;
                    next_dir = 1'b0;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    // Falling, remember direction = right
                    next_state = FALLING;
                    next_dir = 1'b1;
                end else if (bump_left || bump_right) begin
                    // On bump, switch direction to left
                    next_state = WALK_LEFT;
                    next_dir = 1'b0;
                end else begin
                    // Remain walking right
                    next_state = WALK_RIGHT;
                    next_dir = 1'b1;
                end
            end

            FALLING: begin
                if (ground == 1'b1) begin
                    // Land, resume walking in stored direction
                    if (dir == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                    // direction stays the same
                    next_dir = dir;
                end else begin
                    // Keep falling, ignore bumps
                    next_state = FALLING;
                    next_dir = dir;
                end
            end

            default: begin
                next_state = WALK_LEFT;
                next_dir = 1'b0;
            end
        endcase
    end

    // Moore outputs depend on current state
    always @* begin
        walk_left  = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
        aaah       = (state == FALLING);
    end

endmodule