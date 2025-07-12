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

// Mode encoding (2 bits)
localparam MODE_WALK  = 2'b00;
localparam MODE_FALL  = 2'b01;
localparam MODE_DIG   = 2'b10;

reg dir;    // 0 = left, 1 = right
reg [1:0] mode;

wire walking = (mode == MODE_WALK);
wire falling = (mode == MODE_FALL);
wire digging_state = (mode == MODE_DIG);

// Next state variables
reg dir_next;
reg [1:0] mode_next;

always @(*) begin
    // Default next values are current values
    dir_next = dir;
    mode_next = mode;

    if (falling) begin
        // Falling: wait for ground to come back to resume walking in same direction
        if (ground)
            mode_next = MODE_WALK;
        else
            mode_next = MODE_FALL;
        // Direction unchanged when falling
        dir_next = dir;

    end else if (digging_state) begin
        // Digging: continue digging if ground, else fall when ground lost
        if (!ground)
            mode_next = MODE_FALL;
        else
            mode_next = MODE_DIG;
        // Direction unchanged when digging
        dir_next = dir;

    end else if (walking) begin
        // Walking: highest priority fall, then dig, then bumps
        if (!ground) begin
            // Ground lost: start falling
            mode_next = MODE_FALL;
            dir_next = dir;
        end else if (dig) begin
            // Start digging only if ground present and walking
            mode_next = MODE_DIG;
            dir_next = dir;
        end else begin
            // Handle bumps if walking and ground present
            if (bump_left || bump_right) begin
                // On bump(s), switch direction
                // Direction change is same for bump_left, bump_right or both
                dir_next = (bump_left || bump_right) ? ~dir : dir;
                mode_next = MODE_WALK; // remain walking
            end else begin
                // No bumps: keep walking and direction
                dir_next = dir;
                mode_next = MODE_WALK;
            end
        end
    end else begin
        // Default fallback (shouldn't occur): walk left
        dir_next = 1'b0;
        mode_next = MODE_WALK;
    end
end

// State registers with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        dir <= 1'b0;      // left
        mode <= MODE_WALK;
    end else begin
        dir <= dir_next;
        mode <= mode_next;
    end
end

// Outputs derived from mode and direction
assign walk_left  = walking && (dir == 1'b0);
assign walk_right = walking && (dir == 1'b1);
assign aaah       = falling;
assign digging    = digging_state;

endmodule