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

//////////////////////////////////////////////////////////////////////////////
// Input registering to reduce glitches and power
//////////////////////////////////////////////////////////////////////////////
reg bump_left_r, bump_right_r, ground_r, dig_r;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        bump_left_r  <= 1'b0;
        bump_right_r <= 1'b0;
        ground_r     <= 1'b1; // assume starts on ground
        dig_r        <= 1'b0;
    end else begin
        bump_left_r  <= bump_left;
        bump_right_r <= bump_right;
        ground_r     <= ground;
        dig_r        <= dig;
    end
end

//////////////////////////////////////////////////////////////////////////////
// One-hot FSM mode encoding
// 4 states: walk, dig, fall, splat
//////////////////////////////////////////////////////////////////////////////
localparam WALK = 4'b0001;
localparam DIG  = 4'b0010;
localparam FALL = 4'b0100;
localparam SPLAT= 4'b1000;

reg [3:0] mode, next_mode;

reg direction, next_direction; // 0=left, 1=right

// fall timer counts up to 21; 5 bits enough
reg [4:0] fall_timer, next_fall_timer;

//////////////////////////////////////////////////////////////////////////////
// Asynchronous reset registers
//////////////////////////////////////////////////////////////////////////////
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        mode       <= WALK;
        direction  <= 1'b0;  // walk left
        fall_timer <= 5'd0;
    end else begin
        mode       <= next_mode;
        direction  <= next_direction;
        fall_timer <= next_fall_timer;
    end
end

//////////////////////////////////////////////////////////////////////////////
// Next state logic - combinational
// Priority: SPLAT is absorbing
// FALL > DIG > WALK (with bump direction update)
// Only update fall_timer when in FALL, else zero
//////////////////////////////////////////////////////////////////////////////
always_comb begin
    // Defaults to hold current state
    next_mode       = mode;
    next_direction  = direction;
    next_fall_timer = (mode == FALL) ? fall_timer : 5'd0;

    if (mode == SPLAT) begin
        // Forever splatted
        next_mode       = SPLAT;
        next_fall_timer = 5'd0;
        next_direction  = direction; // irrelevant
    end else if (mode == FALL) begin
        if (ground_r) begin
            // Landed: check if splatter
            if (fall_timer > 5'd20) begin
                next_mode = SPLAT;
            end else begin
                next_mode = WALK;
            end
            next_fall_timer = 5'd0;
            next_direction  = direction; // no change on landing
        end else begin
            // Still falling: increment timer up to max 21
            next_mode = FALL;
            if (fall_timer < 5'd21)
                next_fall_timer = fall_timer + 5'd1;
            else
                next_fall_timer = fall_timer;
            next_direction = direction; // direction stable while falling
        end
    end else if (mode == DIG) begin
        if (!ground_r) begin
            // Fall if ground lost while digging
            next_mode       = FALL;
            next_fall_timer = 5'd1;  // start counting fall time at 1
            next_direction  = direction; // retain direction
        end else begin
            // Continue digging
            next_mode       = DIG;
            next_fall_timer = 5'd0;
            next_direction  = direction;
        end
    end else if (mode == WALK) begin
        // Priority order: fall > dig > bump direction change
        if (!ground_r) begin
            // Start falling
            next_mode       = FALL;
            next_fall_timer = 5'd1;
            next_direction  = direction;
        end else if (dig_r) begin
            // Start digging on ground
            next_mode       = DIG;
            next_fall_timer = 5'd0;
            next_direction  = direction;
        end else if (bump_left_r || bump_right_r) begin
            // Update direction based on bump inputs:
            // Both bump: toggle direction
            // bump_left only: walk right (1)
            // bump_right only: walk left (0)
            next_mode       = WALK;
            next_fall_timer = 5'd0;
            if (bump_left_r && bump_right_r)
                next_direction = ~direction;
            else if (bump_left_r)
                next_direction = 1'b1;
            else if (bump_right_r)
                next_direction = 1'b0;
            else
                next_direction = direction; // safe fallback
        end else begin
            // Continue walking, no changes
            next_mode       = WALK;
            next_fall_timer = 5'd0;
            next_direction  = direction;
        end
    end else begin
        // Safety: unexpected mode, reset to walk left
        next_mode       = WALK;
        next_direction  = 1'b0;
        next_fall_timer = 5'd0;
    end
end

//////////////////////////////////////////////////////////////////////////////
// Moore outputs depend only on current registered state
//////////////////////////////////////////////////////////////////////////////
assign walk_left  = (mode == WALK) && (direction == 1'b0);
assign walk_right = (mode == WALK) && (direction == 1'b1);
assign aaah       = (mode == FALL);
assign digging    = (mode == DIG);

endmodule