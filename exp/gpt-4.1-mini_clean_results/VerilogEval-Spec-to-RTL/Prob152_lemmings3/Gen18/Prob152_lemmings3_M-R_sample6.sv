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

// State encoding: [2] mode: 0=WALK, 1=FALL, 2=DIG
// [1:0] direction for WALK states: 0=left (00), 1=right (01)
// For FALL and DIG states, direction bits retained from last WALK state
localparam WALK_LEFT  = 3'b000,
           WALK_RIGHT = 3'b001,
           FALL_LEFT  = 3'b100,
           FALL_RIGHT = 3'b101,
           DIG_LEFT   = 3'b010,
           DIG_RIGHT  = 3'b011;

reg [2:0] state, next_state;

wire walking = (state[2] == 1'b0);  // mode == WALK (top bit 0)
wire falling = (state[2] == 1'b1) && (state[1] == 1'b0); // mode FALL encoded as 100 or 101 (top bit=1, middle bit=0)
wire digging_mode = (state[2] == 1'b0) && (state[1] == 1'b1); // DIG encoded as 010 or 011 (top bit=0, middle bit=1)

// Extract direction bit (LSB of state)
wire dir = state[0];

// Determine if bumped (either side)
wire bumped = bump_left | bump_right;

always @(*) begin
    next_state = state;

    if (walking) begin
        if (!ground) begin
            // fall: go to FALL, preserve direction
            next_state = {1'b1, 1'b0, dir};
        end else if (dig) begin
            // dig: go to DIG, preserve direction
            next_state = {1'b0, 1'b1, dir};
        end else if (bumped) begin
            // bump: flip direction if bumped on any side
            // According to problem, bump_left or bump_right flips direction
            // Both bump: flip direction
            // So flip direction bit on bump
            next_state = {1'b0, 1'b0, ~dir};
        end else begin
            // remain walking same direction
            next_state = state;
        end
    end else if (falling) begin
        if (ground) begin
            // landed: go back to walking, preserve direction
            next_state = {1'b0, 1'b0, dir};
        end else begin
            // keep falling
            next_state = state;
        end
    end else begin // digging_mode
        if (!ground) begin
            // no ground under dig: fall preserving direction
            next_state = {1'b1, 1'b0, dir};
        end else begin
            // continue digging
            next_state = state;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT; // start walking left
    end else begin
        state <= next_state;
    end
end

// Output logic (Moore outputs)
assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = falling;
assign digging    = digging_mode;

endmodule