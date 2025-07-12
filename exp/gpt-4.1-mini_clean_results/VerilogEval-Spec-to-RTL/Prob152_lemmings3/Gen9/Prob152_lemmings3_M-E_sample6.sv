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

// State encoding: 3 bits to include direction (L=0, R=1) and behavior
localparam WALK_LEFT  = 3'b000;
localparam WALK_RIGHT = 3'b001;
localparam FALL_LEFT  = 3'b010;
localparam FALL_RIGHT = 3'b011;
localparam DIG_LEFT   = 3'b100;
localparam DIG_RIGHT  = 3'b101;

reg [2:0] state, next_state;

// Asynchronous reset to WALK_LEFT on posedge areset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

// Next-state logic
always @(*) begin
    next_state = state; // default hold

    case(state)
        WALK_LEFT: begin
            if (!ground)
                next_state = FALL_LEFT; // fall on no ground
            else if (dig)
                next_state = DIG_LEFT;  // start digging if dig=1 and on ground
            else if (bump_left || bump_right) begin
                // bump priority: both bumps toggle direction
                if (bump_left && bump_right)
                    next_state = WALK_RIGHT; // toggle direction
                else if (bump_left)
                    next_state = WALK_RIGHT; // bump left => walk right
                else // bump_right only
                    next_state = WALK_LEFT;  // bump right => walk left (already left)
            end
            // else remain WALK_LEFT
        end

        WALK_RIGHT: begin
            if (!ground)
                next_state = FALL_RIGHT;
            else if (dig)
                next_state = DIG_RIGHT;
            else if (bump_left || bump_right) begin
                if (bump_left && bump_right)
                    next_state = WALK_LEFT;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
        end

        FALL_LEFT: begin
            if (ground)
                next_state = WALK_LEFT; // resume walking after fall
            else
                next_state = FALL_LEFT; // stay falling
        end

        FALL_RIGHT: begin
            if (ground)
                next_state = WALK_RIGHT;
            else
                next_state = FALL_RIGHT;
        end

        DIG_LEFT: begin
            if (!ground)
                next_state = FALL_LEFT; // fall if ground lost during digging
            else
                next_state = DIG_LEFT;  // continue digging
        end

        DIG_RIGHT: begin
            if (!ground)
                next_state = FALL_RIGHT;
            else
                next_state = DIG_RIGHT;
        end

        default: next_state = WALK_LEFT; // safety fallback
    endcase
end

// Outputs derived from current state (Moore outputs)
assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
assign digging    = (state == DIG_LEFT)  || (state == DIG_RIGHT);

endmodule