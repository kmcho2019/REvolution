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
localparam WALK_LEFT  = 3'd0;
localparam WALK_RIGHT = 3'd1;
localparam DIG_LEFT   = 3'd2;
localparam DIG_RIGHT  = 3'd3;
localparam FALLING    = 3'd4;

reg [2:0] state, next_state;
reg       saved_dir, next_saved_dir; // 0=left,1=right; saved walking dir before falling

// Asynchronous reset and state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        saved_dir <= 1'b0; // walking left
    end else begin
        state <= next_state;
        saved_dir <= next_saved_dir;
    end
end

// Next state logic
always @* begin
    // Defaults
    next_state = state;
    next_saved_dir = saved_dir;

    case (state)
        WALK_LEFT: begin
            // Precedence order: fall > dig > bump
            if (ground == 1'b0) begin
                // Fall, save walking dir
                next_state = FALLING;
                next_saved_dir = 1'b0;
            end else if (dig == 1'b1) begin
                // Start digging left if on ground
                next_state = DIG_LEFT;
                next_saved_dir = 1'b0;
            end else if (bump_left | bump_right) begin
                // Switch direction to right walking
                next_state = WALK_RIGHT;
                next_saved_dir = 1'b1;
            end else begin
                next_state = WALK_LEFT;
                next_saved_dir = 1'b0;
            end
        end

        WALK_RIGHT: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
                next_saved_dir = 1'b1;
            end else if (dig == 1'b1) begin
                next_state = DIG_RIGHT;
                next_saved_dir = 1'b1;
            end else if (bump_left | bump_right) begin
                next_state = WALK_LEFT;
                next_saved_dir = 1'b0;
            end else begin
                next_state = WALK_RIGHT;
                next_saved_dir = 1'b1;
            end
        end

        DIG_LEFT: begin
            // dig continues while ground=1
            // if ground lost, fall; bumps ignored; dig ignored while digging
            if (ground == 1'b0) begin
                next_state = FALLING;
                // saved_dir remains same as before fall (walking direction)
                next_saved_dir = 1'b0;
            end else begin
                next_state = DIG_LEFT;
                next_saved_dir = 1'b0;
            end
        end

        DIG_RIGHT: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
                next_saved_dir = 1'b1;
            end else begin
                next_state = DIG_RIGHT;
                next_saved_dir = 1'b1;
            end
        end

        FALLING: begin
            if (ground == 1'b1) begin
                // Recover walking in saved_dir
                if (saved_dir == 1'b0) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
                // saved_dir remains for next fall
                next_saved_dir = saved_dir;
            end else begin
                // Remain falling
                next_state = FALLING;
                next_saved_dir = saved_dir;
            end
        end

        default: begin
            // Should not occur; reset to WALK_LEFT
            next_state = WALK_LEFT;
            next_saved_dir = 1'b0;
        end
    endcase
end

// Outputs as Moore FSM: functions of state only
assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);
assign aaah       = (state == FALLING);

endmodule