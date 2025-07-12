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

    // 5-bit fall counter saturating at 21
    reg [4:0] fall_count, next_fall_count;

    // Extract current state and direction
    wire [1:0] state = state_dir[1:0];
    wire dir = state_dir[2];

    // Bump signals for clarity and priority handling
    wire bump_both       = bump_left & bump_right;
    wire bump_only_left  = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;

    // Combinational next state and fall counter logic
    always @(*) begin
        // Defaults: hold current state, direction, and fall count
        next_state_dir = state_dir;
        next_fall_count = fall_count;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Ground disappeared: start falling
                    next_state_dir[1:0] = FALL;
                    next_fall_count = 5'd1;
                    next_state_dir[2] = dir;
                end else if (dig) begin
                    // Start digging only if walking on ground
                    next_state_dir[1:0] = DIG;
                    next_fall_count = 5'd0;
                    next_state_dir[2] = dir;
                end else begin
                    // Remain walking; handle bumps only now
                    next_state_dir[1:0] = WALK;
                    next_fall_count = 5'd0;
                    if (bump_both) begin
                        next_state_dir[2] = ~dir; // toggle direction
                    end else if (bump_only_left) begin
                        next_state_dir[2] = 1'b1; // bump left => walk right
                    end else if (bump_only_right) begin
                        next_state_dir[2] = 1'b0; // bump right => walk left
                    end else begin
                        next_state_dir[2] = dir; // no bump, keep direction
                    end
                end
            end

            FALL: begin
                if (!ground) begin
                    // Continue falling, increment fall count saturating at 21
                    next_state_dir[1:0] = FALL;
                    next_state_dir[2] = dir;
                    next_fall_count = (fall_count < 5'd21) ? fall_count + 1'b1 : 5'd21;
                end else begin
                    // Landed: check if splatter or resume walking
                    if (fall_count > 5'd20) begin
                        // Splatter forever
                        next_state_dir[1:0] = SPLAT;
                        next_state_dir[2] = dir; // direction retained but unused
                        next_fall_count = 5'd0;
                    end else begin
                        // Resume walking
                        next_state_dir[1:0] = WALK;
                        next_state_dir[2] = dir;
                        next_fall_count = 5'd0;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // Ground disappeared while digging: start falling
                    next_state_dir[1:0] = FALL;
                    next_state_dir[2] = dir;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging
                    next_state_dir[1:0] = DIG;
                    next_state_dir[2] = dir;
                    next_fall_count = 5'd0;
                end
            end

            SPLAT: begin
                // Remain splattered forever, outputs zero
                next_state_dir = state_dir;
                next_fall_count = 5'd0;
            end

            default: begin
                // Defensive default: walk left
                next_state_dir = {1'b0, WALK};
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Sequential block with asynchronous posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_dir <= {1'b0, WALK};  // walk left
            fall_count <= 5'd0;
        end else begin
            state_dir <= next_state_dir;
            fall_count <= next_fall_count;
        end
    end

    // Moore outputs
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule