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

// Mode encoding: 2 bits
localparam MODE_WALK  = 2'b00;
localparam MODE_FALL  = 2'b01;
localparam MODE_DIG   = 2'b10;

reg [1:0] mode, mode_next;      // walking, falling, digging
reg       direction, direction_next; // 0=left, 1=right

// Async reset and state registers
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        direction <= 1'b0; // start walking left
    end else begin
        mode <= mode_next;
        direction <= direction_next;
    end
end

// Next state logic
always @(*) begin
    // Default: hold current values
    mode_next = mode;
    direction_next = direction;

    case (mode)
        MODE_FALL: begin
            // Falling: if ground appears, resume walking same direction; else keep falling
            if (ground) begin
                mode_next = MODE_WALK;
                // direction unchanged
            end
            // bumps or dig do not affect falling state
        end

        MODE_DIG: begin
            // Digging: continue digging if ground present
            // If ground lost, fall with same direction
            if (!ground) begin
                mode_next = MODE_FALL;
                // direction unchanged
            end
            // bumps or dig input ignored in dig mode
        end

        MODE_WALK: begin
            // Walking mode: priority falling > digging > bumps
            if (!ground) begin
                // Fall if no ground
                mode_next = MODE_FALL;
            end else if (dig) begin
                // Start digging only if on ground and walking
                mode_next = MODE_DIG;
            end else begin
                // Handle bumps to switch direction, bumps only considered in walking mode on ground
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    direction_next = ~direction;
                end else if (bump_left) begin
                    // bump left -> walk right
                    direction_next = 1'b1;
                end else if (bump_right) begin
                    // bump right -> walk left
                    direction_next = 1'b0;
                end
                // else keep current direction
            end
        end

        default: begin
            // Safety fallback: reset to walk left
            mode_next = MODE_WALK;
            direction_next = 1'b0;
        end
    endcase
end

// Outputs derived from mode and direction
assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule