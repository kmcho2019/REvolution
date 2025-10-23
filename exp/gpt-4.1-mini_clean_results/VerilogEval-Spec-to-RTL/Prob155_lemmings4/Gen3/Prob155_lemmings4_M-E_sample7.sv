module TopModule (
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

// Encoding:
// mode bits (state[2:1]):
// 2'b00 = walk
// 2'b01 = dig
// 2'b10 = fall
// 2'b11 = splat
// direction bit (state[0]):
// 0 = left, 1 = right (only meaningful for walk, dig, fall)

reg [2:0] state, next_state;
reg [4:0] fall_timer, next_fall_timer;

// Synchronous reset and state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b000;       // walk left (mode=00, dir=0)
        fall_timer <= 5'd0;
    end else begin
        state <= next_state;
        fall_timer <= next_fall_timer;
    end
end

// Combinational next state logic
always @(*) begin
    // Defaults
    next_state = state;
    next_fall_timer = fall_timer;

    // Decode current mode and direction
    wire [1:0] mode = state[2:1];
    wire direction = state[0];

    case (mode)
        2'b11: begin // splat mode - remain forever
            next_state = state;
            next_fall_timer = 5'd0;
        end
        2'b10: begin // falling
            if (ground) begin
                // landed: check fall time to splat or walk
                if (fall_timer > 5'd20) begin
                    // splat
                    next_state = 3'b111; // splat mode, dir ignored
                    next_fall_timer = 5'd0;
                end else begin
                    // resume walking, keep direction
                    next_state = {2'b00, direction};
                    next_fall_timer = 5'd0;
                end
            end else begin
                // continue falling, increment timer saturating at 31
                next_state = state;
                if (fall_timer < 5'd31)
                    next_fall_timer = fall_timer + 1'b1;
                else
                    next_fall_timer = fall_timer;
            end
        end
        2'b01: begin // digging
            if (!ground) begin
                // ground lost: start falling with same direction
                next_state = {2'b10, direction};
                next_fall_timer = 5'd1;
            end else begin
                // continue digging
                next_state = state;
                next_fall_timer = 5'd0;
            end
        end
        2'b00: begin // walking
            if (!ground) begin
                // fall: enter falling mode, reset timer
                next_state = {2'b10, direction};
                next_fall_timer = 5'd1;
            end else if (dig) begin
                // start digging only if on ground walking
                next_state = {2'b01, direction};
                next_fall_timer = 5'd0;
            end else begin
                // walking on ground and not digging
                next_fall_timer = 5'd0;

                // bump priority handling: change direction accordingly
                // bump_left=1 and bump_right=0 => walk right (dir=1)
                // bump_right=1 and bump_left=0 => walk left (dir=0)
                // bump_left=1 and bump_right=1 => toggle dir
                // else maintain direction

                if (bump_left && bump_right) begin
                    // toggle direction
                    next_state = {2'b00, ~direction};
                end else if (bump_left) begin
                    // bumped left, go right
                    next_state = {2'b00, 1'b1};
                end else if (bump_right) begin
                    // bumped right, go left
                    next_state = {2'b00, 1'b0};
                end else begin
                    // no bump, continue walking same direction
                    next_state = state;
                end
            end
        end
        default: begin
            // Should never happen; safe reset to walk left
            next_state = 3'b000;
            next_fall_timer = 5'd0;
        end
    endcase
end

// Outputs: Moore - depend only on current state
assign walk_left  = (state[2:1] == 2'b00) && (state[0] == 1'b0);
assign walk_right = (state[2:1] == 2'b00) && (state[0] == 1'b1);
assign aaah       = (state[2:1] == 2'b10);
assign digging    = (state[2:1] == 2'b01);

endmodule