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
localparam WALK_LEFT     = 3'd0;
localparam WALK_RIGHT    = 3'd1;
localparam DIGGING_LEFT  = 3'd2;
localparam DIGGING_RIGHT = 3'd3;
localparam FALLING_LEFT  = 3'd4;
localparam FALLING_RIGHT = 3'd5;

reg [2:0] state, next_state;

// Sequential state update with asynchronous positive edge reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    // Default hold state
    next_state = state;

    case(state)
        WALK_LEFT: begin
            if (!ground) begin
                // Start falling left
                next_state = FALLING_LEFT;
            end else if (dig) begin
                // Start digging left if on ground and not falling
                next_state = DIGGING_LEFT;
            end else if (bump_left || bump_right) begin
                // Switch direction when bumped (either side)
                next_state = WALK_RIGHT;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bump_left || bump_right) begin
                next_state = WALK_LEFT;
            end
        end

        DIGGING_LEFT: begin
            if (!ground) begin
                // Digging ended, start falling left
                next_state = FALLING_LEFT;
            end
            // else remain digging (ignore bump and dig inputs)
        end

        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
            end
            // else remain digging
        end

        FALLING_LEFT: begin
            if (ground) begin
                // Landed, resume walking left
                next_state = WALK_LEFT;
            end
            // else remain falling
        end

        FALLING_RIGHT: begin
            if (ground) begin
                next_state = WALK_RIGHT;
            end
            // else remain falling
        end

        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Output logic (Moore FSM: outputs depend only on state)
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
        DIGGING_LEFT: begin
            walk_left = 1;
            digging = 1;
        end
        DIGGING_RIGHT: begin
            walk_right = 1;
            digging = 1;
        end
        FALLING_LEFT: begin
            aaah = 1;
        end
        FALLING_RIGHT: begin
            aaah = 1;
        end
    endcase
end

endmodule