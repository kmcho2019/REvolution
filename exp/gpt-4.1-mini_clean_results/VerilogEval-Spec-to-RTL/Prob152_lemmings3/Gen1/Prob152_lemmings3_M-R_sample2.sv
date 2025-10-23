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

    // State encoding
    localparam WALKING = 1'b0;
    localparam FALLING = 1'b1;

    reg state, next_state;
    reg dir, next_dir;           // 0=left, 1=right
    reg digging_reg, next_digging;
    reg saved_dir, next_saved_dir;

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir <= 1'b0;          // start walking left
            digging_reg <= 1'b0;
            saved_dir <= 1'b0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            digging_reg <= next_digging;
            saved_dir <= next_saved_dir;
        end
    end

    // Combinational next state logic
    always @* begin
        // Default assignments: hold current values
        next_state = state;
        next_dir = dir;
        next_digging = digging_reg;
        next_saved_dir = saved_dir;

        case (state)
            WALKING: begin
                if (ground == 1'b0) begin
                    // Start falling: save current walking direction, clear digging
                    next_state = FALLING;
                    next_saved_dir = dir;
                    next_digging = 1'b0;
                end else if (digging_reg) begin
                    // Currently digging and ground present -> continue digging
                    // If ground lost while digging, start falling
                    if (ground == 1'b1) begin
                        // Continue digging and same direction
                        next_state = WALKING;
                        next_digging = 1'b1;
                    end else begin
                        next_state = FALLING;
                        next_saved_dir = dir;
                        next_digging = 1'b0;
                    end
                end else begin
                    // Not digging and walking on ground
                    if (dig == 1'b1) begin
                        // Start digging
                        next_digging = 1'b1;
                        // Direction unchanged
                    end else if (bump_left | bump_right) begin
                        // Switch walking direction on any bump
                        next_dir = ~dir;
                        // Stop digging if was digging (but here digging=0)
                        next_digging = 1'b0;
                    end else begin
                        // No change
                        next_digging = 1'b0;
                    end
                    // Stay in walking state
                    next_state = WALKING;
                    // saved_dir irrelevant here
                    next_saved_dir = saved_dir;
                end
            end

            FALLING: begin
                // When ground reappears, resume walking in saved direction
                if (ground == 1'b1) begin
                    next_state = WALKING;
                    next_dir = saved_dir;
                    next_digging = 1'b0;
                    next_saved_dir = saved_dir; // retain saved_dir for next fall
                end else begin
                    // Continue falling, no digging
                    next_state = FALLING;
                    next_digging = 1'b0;
                    next_saved_dir = saved_dir;
                end
            end

            default: begin
                // Safety fallback
                next_state = WALKING;
                next_dir = 1'b0;
                next_digging = 1'b0;
                next_saved_dir = 1'b0;
            end
        endcase
    end

    // Outputs are Moore outputs depending on current state
    assign walk_left  = (state == WALKING) && (dir == 1'b0) && (digging_reg == 1'b0);
    assign walk_right = (state == WALKING) && (dir == 1'b1) && (digging_reg == 1'b0);
    assign digging    = (state == WALKING) && (digging_reg == 1'b1);
    assign aaah       = (state == FALLING);

endmodule