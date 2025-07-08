module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    localparam WALK_LEFT    = 2'd0;
    localparam WALK_RIGHT   = 2'd1;
    localparam DIGGING_LEFT = 2'd2;
    localparam DIGGING_RIGHT= 2'd3;

    reg [1:0] state, next_state;

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        // Priority: falling > digging > switching directions
        if (ground == 0) begin
            // Falling: no state change here, remain in current state
            // Falling disables bump and dig effect, so no transition
            // But digging ends when ground=0, so return to walking state
            if (state == DIGGING_LEFT)
                next_state = WALK_LEFT;
            else if (state == DIGGING_RIGHT)
                next_state = WALK_RIGHT;
            else
                next_state = state;
        end else begin
            // ground=1
            case (state)
                WALK_LEFT: begin
                    // If dig=1 start digging
                    if (dig)
                        next_state = DIGGING_LEFT;
                    else if (bump_left || bump_right) begin
                        // Switch direction if bumped either side
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
                WALK_RIGHT: begin
                    if (dig)
                        next_state = DIGGING_RIGHT;
                    else if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
                DIGGING_LEFT: begin
                    // Continue digging if ground=1 and not falling
                    // If ground=0 would have already returned to WALK_LEFT above
                    next_state = DIGGING_LEFT;
                end
                DIGGING_RIGHT: begin
                    // Similar for right dig
                    next_state = DIGGING_RIGHT;
                end
                default: next_state = WALK_LEFT;
            endcase
        end
    end

    // Outputs (Moore outputs depend only on state and inputs)
    always @(*) begin
        // Defaults
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        if (ground == 0) begin
            // Falling
            aaah = 1;
            walk_left = 0;
            walk_right = 0;
            digging = 0;
        end else begin
            // ground=1
            case(state)
                WALK_LEFT: begin
                    walk_left = 1;
                    aaah = 0;
                    digging = 0;
                end
                WALK_RIGHT: begin
                    walk_right = 1;
                    aaah = 0;
                    digging = 0;
                end
                DIGGING_LEFT: begin
                    walk_left = 1;
                    digging = 1;
                    aaah = 0;
                end
                DIGGING_RIGHT: begin
                    walk_right = 1;
                    digging = 1;
                    aaah = 0;
                end
                default: begin
                    walk_left = 1;
                    aaah = 0;
                    digging = 0;
                end
            endcase
        end
    end

endmodule