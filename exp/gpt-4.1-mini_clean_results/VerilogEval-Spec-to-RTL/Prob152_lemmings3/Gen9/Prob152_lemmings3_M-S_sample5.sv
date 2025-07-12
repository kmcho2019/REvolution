module TopModule(
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

localparam WALK_L = 3'd0;
localparam WALK_R = 3'd1;
localparam FALL_L = 3'd2;
localparam FALL_R = 3'd3;
localparam DIG_L  = 3'd4;
localparam DIG_R  = 3'd5;

reg [2:0] mode, next_mode;

always @(*) begin
    next_mode = mode;
    case (mode)
        WALK_L: begin
            if (!ground)       next_mode = FALL_L;
            else if (dig)      next_mode = DIG_L;
            else if (bump_left || (bump_left && bump_right)) next_mode = WALK_R;
            else if (bump_right) next_mode = WALK_L; // stays left if bumped right (actually switches to left), but bump_right means switch left
            // Actually, bump_right means switch left, so no change if already left.
            // So: if bumped left: walk right; if bumped right: walk left; if both, walk right.
            // Re-check carefully:
            // bump_left = 1 => walk right (WALK_R)
            // bump_right=1 => walk left (WALK_L)
            // bump_left & bump_right = walk right (WALK_R)
            // So here:
            // if bump_left: walk right
            // else if bump_right: walk left
            // else no change
            if (bump_left)      next_mode = WALK_R;
            else if (bump_right)next_mode = WALK_L;
        end
        WALK_R: begin
            if (!ground)       next_mode = FALL_R;
            else if (dig)      next_mode = DIG_R;
            else if (bump_left) next_mode = WALK_R;
            else if (bump_right) next_mode = WALK_L;
            if (bump_left && bump_right) next_mode = WALK_R; // Both bumped => walk right
            // Same logic: if bump_left: walk right (WALK_R)
            // if bump_right: walk left (WALK_L)
            // Both: walk right
            if (bump_left && bump_right) next_mode = WALK_R;
            else if (bump_left)          next_mode = WALK_R;
            else if (bump_right)         next_mode = WALK_L;
        end
        FALL_L: begin
            if (ground)        next_mode = WALK_L;
        end
        FALL_R: begin
            if (ground)        next_mode = WALK_R;
        end
        DIG_L: begin
            if (!ground)       next_mode = FALL_L;
        end
        DIG_R: begin
            if (!ground)       next_mode = FALL_R;
        end
        default: next_mode = WALK_L;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset)
        mode <= WALK_L;
    else
        mode <= next_mode;
end

assign walk_left  = (mode == WALK_L);
assign walk_right = (mode == WALK_R);
assign aaah       = (mode == FALL_L) || (mode == FALL_R);
assign digging    = (mode == DIG_L)  || (mode == DIG_R);

endmodule