module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding - one-hot
    localparam WALK_LEFT  = 3'b001;
    localparam WALK_RIGHT = 3'b010;
    localparam FALLING    = 3'b100;

    reg [2:0] state, next_state;
    reg       direction, next_direction; // 0=left, 1=right - direction to walk when walking or before falling

    // Next state and direction logic
    always @(*) begin
        // Default to hold current state and direction
        next_state = state;
        next_direction = direction;

        case(state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    // Start falling, preserve direction
                    next_state = FALLING;
                    // direction unchanged
                end else begin
                    // On ground and walking left
                    if (bump_left && bump_right) begin
                        // flip direction to right
                        next_state = WALK_RIGHT;
                        next_direction = 1'b1;
                    end else if (bump_left) begin
                        // bump left -> walk right
                        next_state = WALK_RIGHT;
                        next_direction = 1'b1;
                    end else if (bump_right) begin
                        // bump right -> stay/walk left
                        // direction and state unchanged
                    end else begin
                        // no bump
                        // stay walking left
                    end
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    // Start falling, preserve direction
                    next_state = FALLING;
                    // direction unchanged
                end else begin
                    // On ground and walking right
                    if (bump_left && bump_right) begin
                        // flip direction to left
                        next_state = WALK_LEFT;
                        next_direction = 1'b0;
                    end else if (bump_left) begin
                        // bump left -> stay/walk right
                        // direction and state unchanged
                    end else if (bump_right) begin
                        // bump right -> walk left
                        next_state = WALK_LEFT;
                        next_direction = 1'b0;
                    end else begin
                        // no bump
                        // stay walking right
                    end
                end
            end

            FALLING: begin
                if (ground == 1'b1) begin
                    // Landed, resume walking in stored direction
                    if (direction == 1'b0) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                    // direction unchanged
                end else begin
                    // Continue falling, ignore bumps and direction remains
                end
            end

            default: begin
                // Should not happen, reset to WALK_LEFT
                next_state = WALK_LEFT;
                next_direction = 1'b0;
            end
        endcase
    end

    // Sequential state and direction update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 1'b0;
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Outputs as Moore outputs from state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule