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

// Combined state encoding (3 bits total)
// Bits [2:1] = behavior: 00=walking, 01=falling, 10=digging
// Bit 0 = direction: 0=left, 1=right

localparam WALK_LEFT  = 3'b000;
localparam WALK_RIGHT = 3'b001;
localparam FALL_LEFT  = 3'b010;
localparam FALL_RIGHT = 3'b011;
localparam DIG_LEFT   = 3'b100;
localparam DIG_RIGHT  = 3'b101;

reg [2:0] state, next_state;
reg prev_ground;

// Store previous ground to detect edges and stable ground
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_ground <= 1'b1; // assume ground present at reset
    end else begin
        state <= next_state;
        prev_ground <= ground;
    end
end

// Helper signals for current state decoding
wire walking  = (state[2:1] == 2'b00);
wire falling  = (state[2:1] == 2'b01);
wire digging  = (state[2:1] == 2'b10);
wire dir      = state[0]; // 0=left, 1=right

wire stable_ground = (ground == 1'b1) && (prev_ground == 1'b1);

always @(*) begin
    next_state = state; // default hold

    if (walking) begin
        // Priority: fall > dig > bump
        if (ground == 1'b0) begin
            // fall, keep same direction
            next_state = (dir == 1'b0) ? FALL_LEFT : FALL_RIGHT;
        end else if (dig == 1'b1 && stable_ground) begin
            // start digging
            next_state = (dir == 1'b0) ? DIG_LEFT : DIG_RIGHT;
        end else if (stable_ground && (bump_left || bump_right)) begin
            // direction change due to bump
            if (bump_left && bump_right) begin
                // bump on both sides: flip direction
                next_state = (dir == 1'b0) ? WALK_RIGHT : WALK_LEFT;
            end else if (bump_left) begin
                // bump left: walk right
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // bump right: walk left
                next_state = WALK_LEFT;
            end
        end else begin
            // no change
            next_state = state;
        end
    end else if (falling) begin
        if (ground == 1'b1) begin
            // land and resume walking same direction
            next_state = (dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
        end else begin
            next_state = state;
        end
    end else if (digging) begin
        if (ground == 1'b0) begin
            // ground gone while digging: start falling same direction
            next_state = (dir == 1'b0) ? FALL_LEFT : FALL_RIGHT;
        end else begin
            next_state = state;
        end
    end else begin
        // Should never happen, but fallback to WALK_LEFT
        next_state = WALK_LEFT;
    end
end

// Outputs decoded from current state
assign walk_left  = walking && (dir == 1'b0);
assign walk_right = walking && (dir == 1'b1);
assign aaah       = falling;
assign digging    = digging;

endmodule