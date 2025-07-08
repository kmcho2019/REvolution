module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// State encoding
localparam WALK_LEFT  = 3'd0;
localparam WALK_RIGHT = 3'd1;
localparam FALLING    = 3'd2;
localparam DIGGING_L  = 3'd3;
localparam DIGGING_R  = 3'd4;
localparam SPLATTERED = 3'd5;

reg [2:0] state, next_state;
reg [4:0] fall_count, next_fall_count;  // 5 bits to count up to >20
// Store walking direction to resume after fall
// For DIGGING states the direction is implicit
// For FALLING we store direction by a flag
reg fall_dir; // 0 = left, 1 = right
reg fall_dir_next;

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 5'd0;
        fall_dir <= 1'b0;
    end else begin
        state <= next_state;
        fall_count <= next_fall_count;
        fall_dir <= fall_dir_next;
    end
end

// Combinational next state and outputs logic
always @(*) begin
    // Defaults
    next_state = state;
    next_fall_count = fall_count;
    fall_dir_next = fall_dir;

    // Determine outputs by state (Moore)
    case(state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING_L: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        DIGGING_R: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b1;
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase

    // FSM transitions and internal signals
    case(state)
        // Walking states
        WALK_LEFT: begin
            // falling has highest priority
            if (!ground) begin
                next_state = FALLING;
                next_fall_count = 5'd1;
                fall_dir_next = 1'b0; // left
            end
            else if (dig) begin
                next_state = DIGGING_L; // start digging left
            end
            else begin
                // bump conditions (bump on left or right or both)
                if (bump_left || bump_right) begin
                    // switch to walking right
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
                next_fall_count = 5'd0;
                fall_dir_next = 1'b0;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
                next_fall_count = 5'd1;
                fall_dir_next = 1'b1; // right
            end
            else if (dig) begin
                next_state = DIGGING_R; // start digging right
            end
            else begin
                if (bump_left || bump_right) begin
                    // switch to walking left
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
                next_fall_count = 5'd0;
                fall_dir_next = 1'b1;
            end
        end

        // Digging states
        DIGGING_L: begin
            // falling > dig > bump
            // If ground disappears, start falling
            if (!ground) begin
                next_state = FALLING;
                next_fall_count = 5'd1;
                fall_dir_next = 1'b0; // original walking left
            end else begin
                // continue digging, ignore bumps and dig signal during digging
                next_state = DIGGING_L;
                next_fall_count = 5'd0; // reset fall count during digging
            end
        end

        DIGGING_R: begin
            if (!ground) begin
                next_state = FALLING;
                next_fall_count = 5'd1;
                fall_dir_next = 1'b1; // original walking right
            end else begin
                next_state = DIGGING_R;
                next_fall_count = 5'd0;
            end
        end

        // Falling state
        FALLING: begin
            if (!ground) begin
                // continue falling and count
                next_state = FALLING;
                if (fall_count < 5'd31) // limit max count to avoid overflow
                    next_fall_count = fall_count + 5'd1;
                else
                    next_fall_count = fall_count;
                fall_dir_next = fall_dir;
            end else begin
                // hit ground - check splatter condition
                if (fall_count > 5'd20) begin
                    // splatter
                    next_state = SPLATTERED;
                    next_fall_count = 5'd0;
                end else begin
                    // resume walking original direction
                    if (fall_dir == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                    next_fall_count = 5'd0;
                end
            end
        end

        SPLATTERED: begin
            // forever stuck here until reset
            next_state = SPLATTERED;
            next_fall_count = 5'd0;
            fall_dir_next = fall_dir;
        end

        default: begin
            next_state = WALK_LEFT;
            next_fall_count = 5'd0;
            fall_dir_next = 1'b0;
        end
    endcase

end

endmodule