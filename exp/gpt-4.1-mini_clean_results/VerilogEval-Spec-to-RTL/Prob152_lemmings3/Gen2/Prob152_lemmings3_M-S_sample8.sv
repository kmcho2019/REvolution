module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding with direction encoded
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALLING    = 2'd2
    } state_t;

    state_t state, next_state;
    reg digging_reg, next_digging;
    reg saved_dir; // 0 = left, 1 = right, for restoring after falling

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            digging_reg <= 1'b0;
            saved_dir <= 1'b0; // left
        end else begin
            state <= next_state;
            digging_reg <= next_digging;
            saved_dir <= (state == FALLING) ? saved_dir : // keep saved_dir when walking
                         (state == WALK_LEFT)  ? 1'b0 :
                         (state == WALK_RIGHT) ? 1'b1 : saved_dir;
        end
    end

    // Combinational next state and digging logic
    always @* begin
        // Defaults to current values
        next_state = state;
        next_digging = digging_reg;

        case (state)
            FALLING: begin
                digging_reg; // no digging in falling
                if (ground) begin
                    // Ground restored, resume walking in saved_dir, stop digging
                    next_digging = 1'b0;
                    next_state = saved_dir ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    // Still falling
                    next_state = FALLING;
                    next_digging = 1'b0;
                end
            end

            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling, save dir=0 (left)
                    next_state = FALLING;
                    next_digging = 1'b0;
                end else if (digging_reg) begin
                    // Currently digging on ground
                    if (ground) begin
                        // Continue digging
                        next_state = WALK_LEFT;
                        next_digging = 1'b1;
                    end else begin
                        // Ground lost during digging, start falling
                        next_state = FALLING;
                        next_digging = 1'b0;
                    end
                end else begin
                    // Not digging, on ground
                    if (dig) begin
                        // Start digging
                        next_digging = 1'b1;
                        next_state = WALK_LEFT;
                    end else if (bump_left || bump_right) begin
                        // Switch direction on bump
                        next_state = WALK_RIGHT;
                        next_digging = 1'b0;
                    end else begin
                        next_state = WALK_LEFT;
                        next_digging = 1'b0;
                    end
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    // Start falling, save dir=1 (right)
                    next_state = FALLING;
                    next_digging = 1'b0;
                end else if (digging_reg) begin
                    // Currently digging on ground
                    if (ground) begin
                        // Continue digging
                        next_state = WALK_RIGHT;
                        next_digging = 1'b1;
                    end else begin
                        // Ground lost during digging, start falling
                        next_state = FALLING;
                        next_digging = 1'b0;
                    end
                end else begin
                    // Not digging, on ground
                    if (dig) begin
                        // Start digging
                        next_digging = 1'b1;
                        next_state = WALK_RIGHT;
                    end else if (bump_left || bump_right) begin
                        // Switch direction on bump
                        next_state = WALK_LEFT;
                        next_digging = 1'b0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_digging = 1'b0;
                    end
                end
            end

            default: begin
                next_state = WALK_LEFT;
                next_digging = 1'b0;
            end
        endcase
    end

    // Outputs: Moore style
    assign walk_left  = ((state == WALK_LEFT) && (digging_reg == 1'b0));
    assign walk_right = ((state == WALK_RIGHT) && (digging_reg == 1'b0));
    assign digging    = ((state == WALK_LEFT || state == WALK_RIGHT) && digging_reg);
    assign aaah       = (state == FALLING);

endmodule