module TopModule (
    input  clk,
    input  areset,       // asynchronous positive edge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (2 bits)
    localparam [1:0]
        WALK  = 2'd0,
        FALL  = 2'd1,
        DIG   = 2'd2,
        SPLAT = 2'd3;

    // Packed state + direction: [2] = dir, [1:0] = state
    reg [2:0] state_dir, next_state_dir;

    // Fall count saturating at 31 (5 bits)
    reg [4:0] fall_count, next_fall_count;

    // Extract current state and direction
    wire [1:0] state = state_dir[1:0];
    wire dir = state_dir[2];

    // Bump signals decoding
    wire bump_both = bump_left & bump_right;
    wire bump_only_left = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;

    // Next state and fall count combinational logic
    always @(*) begin
        // Default assignments: hold current values
        next_state_dir = state_dir;
        next_fall_count = fall_count;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Ground gone: start falling, fall_count=1
                    next_state_dir[1:0] = FALL;
                    next_fall_count = 5'd1;
                    // direction unchanged
                    next_state_dir[2] = dir;
                end else if (dig) begin
                    // Start digging only if on ground and walking
                    next_state_dir[1:0] = DIG;
                    next_fall_count = 5'd0;
                    next_state_dir[2] = dir;
                end else begin
                    // Still walking on ground, handle bumps with priority
                    next_state_dir[1:0] = WALK;
                    next_fall_count = 5'd0;

                    if (bump_both) begin
                        // Flip direction
                        next_state_dir[2] = ~dir;
                    end else if (bump_only_left) begin
                        // bump_left -> walk right
                        next_state_dir[2] = 1'b1;
                    end else if (bump_only_right) begin
                        // bump_right -> walk left
                        next_state_dir[2] = 1'b0;
                    end else begin
                        // no bump, direction unchanged
                        next_state_dir[2] = dir;
                    end
                end
            end

            FALL: begin
                if (!ground) begin
                    // Continue falling, saturate fall count at 31
                    next_state_dir[1:0] = FALL;
                    next_state_dir[2] = dir;
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 5'd1 : fall_count;
                end else begin
                    // Landed: check if splatter or resume walking
                    if (fall_count > 5'd20) begin
                        // splatter forever
                        next_state_dir[1:0] = SPLAT;
                        next_state_dir[2] = dir; // direction irrelevant here
                        next_fall_count = 5'd0;
                    end else begin
                        // resume walking in same direction
                        next_state_dir[1:0] = WALK;
                        next_state_dir[2] = dir;
                        next_fall_count = 5'd0;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // ground disappeared during digging: fall now
                    next_state_dir[1:0] = FALL;
                    next_state_dir[2] = dir;
                    next_fall_count = 5'd1;
                end else begin
                    // keep digging
                    next_state_dir[1:0] = DIG;
                    next_state_dir[2] = dir;
                    next_fall_count = 5'd0;
                end
            end

            SPLAT: begin
                // Stay splattered forever
                next_state_dir = state_dir;
                next_fall_count = 5'd0;
            end

            default: begin
                // Safe reset to walk left
                next_state_dir = {1'b0, WALK};
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Sequential logic with async posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to walking left, no fall count
            state_dir <= {1'b0, WALK};
            fall_count <= 5'd0;
        end else begin
            state_dir <= next_state_dir;
            fall_count <= next_fall_count;
        end
    end

    // Moore outputs from current state and direction
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule