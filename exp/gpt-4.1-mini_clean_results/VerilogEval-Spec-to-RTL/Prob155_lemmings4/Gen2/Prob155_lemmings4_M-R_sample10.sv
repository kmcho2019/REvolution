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
        WALK = 2'd0,
        FALL = 2'd1,
        DIG  = 2'd2,
        SPLAT= 2'd3;

    // We pack state and direction into a single 3-bit register:
    // [2] = dir (0=left,1=right), [1:0] = state
    reg [2:0] state_dir, next_state_dir;

    // Fall count 5-bit saturating counter
    reg [4:0] fall_count, next_fall_count;

    // Extract current state and direction
    wire [1:0] state = state_dir[1:0];
    wire dir = state_dir[2];

    // Determine bumps combined
    wire bump_both = bump_left & bump_right;
    wire bump_only_left = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;

    // Next state and direction logic (combinational)
    always @(*) begin
        // Default keep current values
        next_state_dir = state_dir;
        next_fall_count = fall_count;

        case(state)
            WALK: begin
                if (!ground) begin
                    // Start falling, reset fall count to 1
                    next_state_dir[1:0] = FALL;
                    next_fall_count = 5'd1;
                    // direction unchanged
                end else if (dig) begin
                    // Start digging, fall count cleared
                    next_state_dir[1:0] = DIG;
                    next_fall_count = 5'd0;
                    // direction unchanged
                end else begin
                    // Handle bumps if any
                    next_state_dir[1:0] = WALK;
                    next_fall_count = 5'd0;
                    if (bump_both)
                        next_state_dir[2] = ~dir;   // reverse direction
                    else if (bump_only_left)
                        next_state_dir[2] = 1'b1;   // walk right
                    else if (bump_only_right)
                        next_state_dir[2] = 1'b0;   // walk left
                    else
                        next_state_dir[2] = dir;    // no change
                end
            end

            FALL: begin
                if (!ground) begin
                    // Continue falling, increment fall_count saturate at 31
                    next_state_dir[1:0] = FALL;
                    next_state_dir[2] = dir;
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 5'd1 : fall_count;
                end else begin
                    // Landed, check if splatter or resume walking
                    if (fall_count > 5'd20) begin
                        next_state_dir[1:0] = SPLAT;
                        next_fall_count = 5'd0;
                        next_state_dir[2] = dir;
                    end else begin
                        next_state_dir[1:0] = WALK;
                        next_fall_count = 5'd0;
                        next_state_dir[2] = dir;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // Ground disappeared: start falling from dig
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
                // Stay splatted forever
                next_state_dir[1:0] = SPLAT;
                next_state_dir[2] = dir;
                next_fall_count = 5'd0;
            end

            default: begin
                // Safe recovery: walk left
                next_state_dir = {1'b0, WALK};
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Sequential block for state_dir and fall_count, asynchronous reset on areset posedge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_dir <= {1'b0, WALK};  // dir=0 (left), state = WALK
            fall_count <= 5'd0;
        end else begin
            state_dir <= next_state_dir;
            fall_count <= next_fall_count;
        end
    end

    // Outputs: Moore style combinational from current state_dir
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule