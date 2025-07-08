module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// State encoding
localparam WALK_LEFT    = 3'd0;
localparam WALK_RIGHT   = 3'd1;
localparam FALLING_LEFT = 3'd2;
localparam FALLING_RIGHT= 3'd3;
localparam DIGGING_LEFT = 3'd4;
localparam DIGGING_RIGHT= 3'd5;

reg [2:0] state, next_state;

// State register with async posedge reset
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

    case(state)
        // Walking left
        WALK_LEFT: begin
            if (!ground) begin
                // ground gone: start falling left
                next_state = FALLING_LEFT;
            end else if (dig) begin
                // Start digging left if ground present and not falling
                next_state = DIGGING_LEFT;
            end else if (bump_left || bump_right) begin
                // Switch direction walking right
                next_state = WALK_RIGHT;
            end
        end
        // Walking right
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bump_left || bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        // Falling left
        FALLING_LEFT: begin
            if (ground) begin
                // back to walking left
                next_state = WALK_LEFT;
            end
            // else remain falling, bumps ignored
        end
        // Falling right
        FALLING_RIGHT: begin
            if (ground) begin
                next_state = WALK_RIGHT;
            end
        end
        // Digging left
        DIGGING_LEFT: begin
            if (!ground) begin
                // no ground means start falling left
                next_state = FALLING_LEFT;
            end
            // else keep digging left
        end
        // Digging right
        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
            end
            // else keep digging right
        end
        default: next_state = WALK_LEFT; // safe default
    endcase
end

// Outputs depend only on state (Moore machine)
assign walk_left = (state == WALK_LEFT) || (state == DIGGING_LEFT);
assign walk_right = (state == WALK_RIGHT) || (state == DIGGING_RIGHT);
assign aaah = (state == FALLING_LEFT) || (state == FALLING_RIGHT);
assign digging = (state == DIGGING_LEFT) || (state == DIGGING_RIGHT);

endmodule