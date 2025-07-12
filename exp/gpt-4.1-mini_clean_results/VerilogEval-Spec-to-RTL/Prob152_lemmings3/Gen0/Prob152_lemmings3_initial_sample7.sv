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
localparam WALK_LEFT  = 2'd0;
localparam WALK_RIGHT = 2'd1;
localparam FALLING    = 2'd2;

reg [1:0] state, next_state;
reg       digging_reg, next_digging;
reg       saved_dir, next_saved_dir; // 0=left, 1=right

// Asynchronous reset and state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        digging_reg <= 1'b0;
        saved_dir <= 1'b0; // walking left
    end else begin
        state <= next_state;
        digging_reg <= next_digging;
        saved_dir <= next_saved_dir;
    end
end

// Next state logic
always @* begin
    // Defaults
    next_state = state;
    next_digging = digging_reg;
    next_saved_dir = saved_dir;

    case (state)
        WALK_LEFT, WALK_RIGHT: begin
            // Walking state (may be digging or not)
            // Determine current walking direction
            // saved_dir tracks walking dir when falling, here it is current direction

            // Handle ground loss (falling has precedence)
            if (ground == 1'b0) begin
                // Start falling, save current walking dir
                next_state = FALLING;
                next_saved_dir = (state == WALK_LEFT) ? 1'b0 : 1'b1;
                next_digging = 1'b0;
            end else if (digging_reg) begin
                // Currently digging, continue digging if ground still present
                if (ground == 1'b1) begin
                    next_state = state; // continue same walking direction
                    next_digging = 1'b1;
                end else begin
                    // ground disappeared, start falling
                    next_state = FALLING;
                    next_saved_dir = (state == WALK_LEFT) ? 1'b0 : 1'b1;
                    next_digging = 1'b0;
                end
            end else begin
                // Not falling, not digging
                // dig signal
                if (dig == 1'b1) begin
                    // start digging if ground and walking
                    next_state = state;
                    next_digging = 1'b1;
                    next_saved_dir = (state == WALK_LEFT) ? 1'b0 : 1'b1;
                end else begin
                    // Check bumps (only if not digging)
                    // If bumped left, walk right
                    // If bumped right, walk left
                    // If both, still switch
                    if (bump_left | bump_right) begin
                        if (state == WALK_LEFT) begin
                            next_state = WALK_RIGHT;
                            next_digging = 1'b0;
                            next_saved_dir = 1'b1;
                        end else begin
                            next_state = WALK_LEFT;
                            next_digging = 1'b0;
                            next_saved_dir = 1'b0;
                        end
                    end else begin
                        // No change
                        next_state = state;
                        next_digging = 1'b0;
                        next_saved_dir = (state == WALK_LEFT) ? 1'b0 : 1'b1;
                    end
                end
            end
        end

        FALLING: begin
            // Falling state
            // If ground reappears, recover walking in saved direction
            if (ground == 1'b1) begin
                if (saved_dir == 1'b0) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
                next_digging = 1'b0;
                // saved_dir remains for next fall
                next_saved_dir = saved_dir;
            end else begin
                // keep falling
                next_state = FALLING;
                next_digging = 1'b0;
                next_saved_dir = saved_dir;
            end
        end

        default: begin
            // Should not occur, default to WALK_LEFT
            next_state = WALK_LEFT;
            next_digging = 1'b0;
            next_saved_dir = 1'b0;
        end
    endcase
end

// Outputs are Moore, purely combinational
assign walk_left  = ((state == WALK_LEFT) && !digging_reg);
assign walk_right = ((state == WALK_RIGHT) && !digging_reg);
assign digging    = ((state == WALK_LEFT) && digging_reg) || ((state == WALK_RIGHT) && digging_reg);
assign aaah       = (state == FALLING);

endmodule