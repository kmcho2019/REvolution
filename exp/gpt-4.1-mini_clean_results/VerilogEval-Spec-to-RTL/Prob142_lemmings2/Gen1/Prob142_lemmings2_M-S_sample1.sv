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

    // States
    localparam WALKING = 1'b0;
    localparam FALLING = 1'b1;

    reg state, next_state;
    reg dir, next_dir; // 0 = left, 1 = right

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir <= 1'b0; // start walking left
        end else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    // Next state and direction logic
    always @* begin
        next_state = state;
        next_dir = dir;

        case (state)
            WALKING: begin
                if (ground == 1'b0) begin
                    // Start falling, keep direction
                    next_state = FALLING;
                    next_dir = dir;
                end else begin
                    // If bumped on either side, flip direction
                    if (bump_left || bump_right)
                        next_dir = ~dir;
                    next_state = WALKING;
                end
            end

            FALLING: begin
                if (ground == 1'b1) begin
                    // Land, resume walking with same direction
                    next_state = WALKING;
                    next_dir = dir;
                end else begin
                    // Continue falling, ignore bumps
                    next_state = FALLING;
                    next_dir = dir;
                end
            end

            default: begin
                next_state = WALKING;
                next_dir = 1'b0;
            end
        endcase
    end

    // Outputs: Moore machine outputs depend only on current state and dir
    always @* begin
        walk_left  = (state == WALKING) && (dir == 1'b0);
        walk_right = (state == WALKING) && (dir == 1'b1);
        aaah       = (state == FALLING);
    end

endmodule