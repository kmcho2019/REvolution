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

    // State encoding (2 bits):
    localparam [1:0]
        WALK  = 2'd0,
        FALL  = 2'd1,
        DIG   = 2'd2,
        SPLAT = 2'd3;

    // Pack state and direction in 3 bits:
    // [2] = direction (0=left,1=right), [1:0] = state
    reg [2:0] state_dir, next_state_dir;

    // 5-bit fall counter saturating at 31
    reg [4:0] fall_count, next_fall_count;

    // Extract fields for clarity
    wire [1:0] state = state_dir[1:0];
    wire dir = state_dir[2];

    // Bump signals
    wire bump_both = bump_left & bump_right;
    wire bump_only_left = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;

    // Next state and fall count logic
    always @(*) begin
        // Defaults: hold current state and counters
        next_state_dir = state_dir;
        next_fall_count = fall_count;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Ground disappeared: start falling
                    next_state_dir[1:0] = FALL;
                    next_fall_count = 5'd1;
                    // Direction unchanged
                    next_state_dir[2] = dir;
                end else if (dig) begin
                    // Start digging only if walking on ground
                    next_state_dir[1:0] = DIG;
                    next_fall_count = 5'd0;
                    next_state_dir[2] = dir;
                end else begin
                    // Stay walking, handle bumps with explicit priority as per Example 2
                    next_state_dir[1:0] = WALK;
                    next_fall_count = 5'd0;
                    if (bump_both) begin
                        // Toggle direction if bumped both sides
                        next_state_dir[2] = ~dir;
                    end else if (bump_only_left) begin
                        // bump_left: walk right
                        next_state_dir[2] = 1'b1;
                    end else if (bump_only_right) begin
                        // bump_right: walk left
                        next_state_dir[2] = 1'b0;
                    end else begin
                        // No bump: direction unchanged
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
                    // Landed on ground: check for splatter
                    if (fall_count > 5'd20) begin
                        // Splatter: cease all actions forever
                        next_state_dir[1:0] = SPLAT;
                        next_state_dir[2] = dir; // direction retained but irrelevant
                        next_fall_count = 5'd0;
                    end else begin
                        // Resume walking in same direction
                        next_state_dir[1:0] = WALK;
                        next_state_dir[2] = dir;
                        next_fall_count = 5'd0;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // Ground disappeared during dig: start falling
                    next_state_dir[1:0] = FALL;
                    next_state_dir[2] = dir;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging on ground
                    next_state_dir[1:0] = DIG;
                    next_state_dir[2] = dir;
                    next_fall_count = 5'd0;
                end
            end

            SPLAT: begin
                // Remain splattered forever
                next_state_dir = state_dir;
                next_fall_count = 5'd0;
            end

            default: begin
                // Safety default: walk left
                next_state_dir = {1'b0, WALK};
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Sequential state and counter update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_dir <= {1'b0, WALK};  // walking left
            fall_count <= 5'd0;
        end else begin
            state_dir <= next_state_dir;
            fall_count <= next_fall_count;
        end
    end

    // Outputs: Moore outputs depend only on current state and direction
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule