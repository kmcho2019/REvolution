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

    // Register previous ground to detect transitions
    reg prev_ground;

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir <= 1'b0; // start walking left
            prev_ground <= 1'b1; // assume ground present on reset
        end else begin
            state <= next_state;
            dir <= next_dir;
            prev_ground <= ground;
        end
    end

    // Next state and direction logic
    always @* begin
        next_state = state;
        next_dir = dir;

        // Detect ground transitions
        wire ground_falling_edge = (prev_ground == 1'b1) && (ground == 1'b0); // ground just disappeared
        wire ground_rising_edge  = (prev_ground == 1'b0) && (ground == 1'b1); // ground just appeared

        case (state)
            WALKING: begin
                if (ground == 1'b0) begin
                    // Start falling, keep direction
                    next_state = FALLING;
                    next_dir = dir;
                end else begin
                    // Only flip direction on bumps if ground is stable (no edge)
                    if (!ground_falling_edge && !ground_rising_edge) begin
                        if (bump_left || bump_right)
                            next_dir = ~dir;
                    end
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