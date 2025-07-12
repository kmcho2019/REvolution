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
    // One-hot states
    localparam WALK_LEFT  = 4'b0001;
    localparam WALK_RIGHT = 4'b0010;
    localparam FALL       = 4'b0100;
    localparam DIG        = 4'b1000;

    reg [3:0] state, next_state;

    // Next state combinational logic
    always @* begin
        next_state = state; // default hold
        case(state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else if (bump_left || bump_right)
                    next_state = WALK_RIGHT; // bump any side flips direction to right
            end

            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else if (bump_left || bump_right)
                    next_state = WALK_LEFT; // bump any side flips direction to left
            end

            FALL: begin
                if (ground)
                    // Resume walking in previous direction (determined by internal flag)
                    // To remember previous direction, we store it on entering FALL
                    // So store direction in a register during state update
                    // But since FALL is a one-hot state with no direction encoded,
                    // We'll track previous direction in a separate reg
                    // But we prefer to avoid extra reg; Instead, store prev direction in a reg:
                    // Implemented below in state update block
                    // Here, next_state assigned in sequential block after restoring
                    // So keep FALL here, and do not update next_state combinationally
                    // Return to either WALK_LEFT or WALK_RIGHT according to stored direction
                    next_state = FALL; // stay FALL until sequential block updates
            end

            DIG: begin
                if (!ground)
                    next_state = FALL;
                // else remain DIG
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // To restore walking direction after FALL, use a separate register to hold direction
    reg walking_dir; // 0 = left, 1 = right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_dir <= 1'b0; // left
        end else begin
            if (state == FALL && ground) begin
                // Exit fall, resume walking in stored direction
                if (walking_dir == 1'b0)
                    state <= WALK_LEFT;
                else
                    state <= WALK_RIGHT;
            end else begin
                state <= next_state;
            end

            // Update walking direction only when walking and changing direction due to bump
            if (state == WALK_LEFT || state == WALK_RIGHT) begin
                if (state == WALK_LEFT && (bump_left || bump_right))
                    walking_dir <= 1'b1; // walk right
                else if (state == WALK_RIGHT && (bump_left || bump_right))
                    walking_dir <= 1'b0; // walk left
                else if (state == DIG || state == FALL) begin
                    // Do not update walking_dir during dig or fall
                    walking_dir <= walking_dir;
                end else begin
                    // When walking without bump, keep direction as is
                    walking_dir <= walking_dir;
                end
            end

            // When entering fall from walking or digging, save direction if coming from walking
            if ((state == WALK_LEFT || state == WALK_RIGHT || state == DIG) && !ground) begin
                // walking_dir is already set appropriately, no change needed
                // Just maintain walking_dir
                walking_dir <= walking_dir;
            end
        end
    end

    // Outputs based on current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule