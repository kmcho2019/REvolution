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
localparam WALK_LEFT    = 3'd0;
localparam WALK_RIGHT   = 3'd1;
localparam FALLING_LEFT = 3'd2;
localparam FALLING_RIGHT= 3'd3;
localparam DIGGING_LEFT = 3'd4;
localparam DIGGING_RIGHT= 3'd5;

reg [2:0] state, next_state;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    // Default to current state
    next_state = state;

    case(state)
        // Walking left state
        WALK_LEFT: begin
            if (!ground) begin
                // Fall has highest precedence
                next_state = FALLING_LEFT;
            end else if (dig) begin
                // Dig if on ground and dig=1
                next_state = DIGGING_LEFT;
            end else if (bump_left || bump_right) begin
                // Switch direction on bump
                next_state = WALK_RIGHT;
            end
        end

        // Walking right state
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bump_left || bump_right) begin
                next_state = WALK_LEFT;
            end
        end

        // Falling left state
        FALLING_LEFT: begin
            if (ground) begin
                // Resume walking left when ground reappears
                next_state = WALK_LEFT;
            end
            // bumps and dig ignored while falling
        end

        // Falling right state
        FALLING_RIGHT: begin
            if (ground) begin
                next_state = WALK_RIGHT;
            end
        end

        // Digging left state
        DIGGING_LEFT: begin
            if (!ground) begin
                // Start falling when ground disappears
                next_state = FALLING_LEFT;
            end
            // bumps ignored while digging
            // if dig=0 while digging, continue digging (no transition)
        end

        // Digging right state
        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
            end
        end

        default: begin
            // Should not happen, reset to WALK_LEFT
            next_state = WALK_LEFT;
        end
    endcase
end

// Output logic: Moore FSM outputs depend only on state
always @(*) begin
    walk_left  = 0;
    walk_right = 0;
    aaah       = 0;
    digging    = 0;

    case(state)
        WALK_LEFT: begin
            walk_left = 1;
        end

        WALK_RIGHT: begin
            walk_right = 1;
        end

        FALLING_LEFT: begin
            aaah = 1;
        end

        FALLING_RIGHT: begin
            aaah = 1;
        end

        DIGGING_LEFT: begin
            walk_left = 1;
            digging = 1;
        end

        DIGGING_RIGHT: begin
            walk_right = 1;
            digging = 1;
        end
    endcase
end

endmodule