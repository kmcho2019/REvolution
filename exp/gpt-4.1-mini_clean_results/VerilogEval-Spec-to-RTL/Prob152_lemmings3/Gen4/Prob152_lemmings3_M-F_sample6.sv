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

    // State encoding as localparams (2-bit)
    localparam [1:0]
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALLING    = 2'd2;

    reg [1:0] state, next_state;
    reg digging_reg, next_digging;
    reg saved_dir; // 0 = left, 1 = right

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            digging_reg <= 1'b0;
            saved_dir <= 1'b0; // left
        end else begin
            state <= next_state;
            digging_reg <= next_digging;

            // Update saved_dir only when walking states
            if (state == WALK_LEFT) begin
                saved_dir <= 1'b0;
            end else if (state == WALK_RIGHT) begin
                saved_dir <= 1'b1;
            end 
            // else saved_dir unchanged (including FALLING)
        end
    end

    // Combinational next state and digging logic
    always @* begin
        // Defaults
        next_state = state;
        next_digging = digging_reg;

        case (state)
            FALLING: begin
                // Disable digging while falling
                next_digging = 1'b0;

                if (ground) begin
                    // Ground restored, resume walking in saved_dir
                    next_state = (saved_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    // Still falling
                    next_state = FALLING;
                end
            end

            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling
                    next_state = FALLING;
                    next_digging = 1'b0;
                end else if (digging_reg) begin
                    // Continue digging on ground
                    if (ground) begin
                        next_state = WALK_LEFT;
                        next_digging = 1'b1;
                    end else begin
                        // Ground lost during digging => falling
                        next_state = FALLING;
                        next_digging = 1'b0;
                    end
                end else begin
                    // Not digging, on ground
                    if (dig) begin
                        next_state = WALK_LEFT;
                        next_digging = 1'b1;
                    end else if (bump_left || bump_right) begin
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
                    // Start falling
                    next_state = FALLING;
                    next_digging = 1'b0;
                end else if (digging_reg) begin
                    // Continue digging on ground
                    if (ground) begin
                        next_state = WALK_RIGHT;
                        next_digging = 1'b1;
                    end else begin
                        // Ground lost during digging => falling
                        next_state = FALLING;
                        next_digging = 1'b0;
                    end
                end else begin
                    // Not digging, on ground
                    if (dig) begin
                        next_state = WALK_RIGHT;
                        next_digging = 1'b1;
                    end else if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                        next_digging = 1'b0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_digging = 1'b0;
                    end
                end
            end

            default: begin
                // Default to WALK_LEFT
                next_state = WALK_LEFT;
                next_digging = 1'b0;
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (state == WALK_LEFT) && !digging_reg;
    assign walk_right = (state == WALK_RIGHT) && !digging_reg;
    assign digging    = ((state == WALK_LEFT) || (state == WALK_RIGHT)) && digging_reg;
    assign aaah       = (state == FALLING);

endmodule