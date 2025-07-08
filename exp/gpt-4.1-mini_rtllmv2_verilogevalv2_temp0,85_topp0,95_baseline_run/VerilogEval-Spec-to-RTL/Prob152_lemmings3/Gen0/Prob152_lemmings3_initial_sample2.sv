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
localparam WALK_LEFT  = 3'd0;
localparam WALK_RIGHT = 3'd1;
localparam FALL_LEFT  = 3'd2;
localparam FALL_RIGHT = 3'd3;
localparam DIG_LEFT   = 3'd4;
localparam DIG_RIGHT  = 3'd5;

reg [2:0] state, next_state;

// State transition logic
always @(*) begin
    // Default next_state is current state
    next_state = state;

    case(state)
        WALK_LEFT: begin
            if (!ground) begin
                // Fall takes precedence
                next_state = FALL_LEFT;
            end else if (dig) begin
                // Start digging if dig=1 on ground and walking
                next_state = DIG_LEFT;
            end else if (bump_left || bump_right) begin
                // Switch direction if bumped
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else if (dig) begin
                next_state = DIG_RIGHT;
            end else if (bump_left || bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALL_LEFT: begin
            // Falling ignores bump and dig
            if (ground) begin
                // Return to walking left when ground returns
                next_state = WALK_LEFT;
            end else begin
                next_state = FALL_LEFT;
            end
        end
        FALL_RIGHT: begin
            if (ground) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = FALL_RIGHT;
            end
        end
        DIG_LEFT: begin
            if (!ground) begin
                // Ground lost while digging => fall
                next_state = FALL_LEFT;
            end else begin
                // Continue digging, bump ignored
                next_state = DIG_LEFT;
            end
        end
        DIG_RIGHT: begin
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else begin
                next_state = DIG_RIGHT;
            end
        end
        default: next_state = WALK_LEFT; // safety default
    endcase
end

// Sequential state register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

// Output logic (Moore outputs depend only on state)
always @(*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case(state)
        WALK_LEFT:  walk_left = 1'b1;
        WALK_RIGHT: walk_right = 1'b1;
        FALL_LEFT,
        FALL_RIGHT: aaah = 1'b1;
        DIG_LEFT,
        DIG_RIGHT:  digging = 1'b1;
    endcase
end

endmodule