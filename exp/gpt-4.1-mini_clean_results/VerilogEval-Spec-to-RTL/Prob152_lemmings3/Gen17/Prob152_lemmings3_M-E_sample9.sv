module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot state encoding
    localparam WALK_LEFT  = 4'b0001;
    localparam WALK_RIGHT = 4'b0010;
    localparam FALL       = 4'b0100;
    localparam DIG        = 4'b1000;

    reg [3:0] state, next_state;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic
    always @* begin
        next_state = state; // default hold

        case (state)
            WALK_LEFT: begin
                // Highest priority: falling
                if (!ground) begin
                    next_state = FALL;
                end 
                // Next: digging
                else if (dig) begin
                    next_state = DIG;
                end 
                // Otherwise, check bumps to change direction
                else if (bump_left || bump_right) begin
                    // If bumped on left or right or both, switch direction
                    next_state = WALK_RIGHT;
                end
                // else stay walking left
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left || bump_right) begin
                    // Switch to walking left on bump(s)
                    next_state = WALK_LEFT;
                end
                // else stay walking right
            end

            FALL: begin
                if (ground)
                    // Return to previous walking direction, 
                    // recover walking direction from saved walk state.
                    // However, since we lost previous state, 
                    // store previous walking direction in a register.
                    // Alternative: add a register to hold last walking direction.

                    // We need to track last walking state before falling.
                    // Use a separate register walking_dir (0=left,1=right)
                    next_state = (last_walk_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                else
                    next_state = FALL;
            end

            DIG: begin
                if (!ground)
                    next_state = FALL;
                else
                    next_state = DIG;
            end
        endcase
    end

    // To remember walking direction before falling, add a register:
    reg last_walk_dir; // 0=left, 1=right

    // Update last_walk_dir when walking states active
    always @(posedge clk or posedge areset) begin
        if (areset)
            last_walk_dir <= 1'b0;
        else begin
            case (state)
                WALK_LEFT:  last_walk_dir <= 1'b0;
                WALK_RIGHT: last_walk_dir <= 1'b1;
                default: ; // retain
            endcase
        end
    end

    // Outputs from state (Moore outputs)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule