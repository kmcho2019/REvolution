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

    // One-hot encoded states (4 states)
    localparam WALK_L = 4'b0001; // walk left
    localparam WALK_R = 4'b0010; // walk right
    localparam FALL   = 4'b0100; // falling (dir stored separately)
    localparam DIG    = 4'b1000; // digging (dir stored separately)
    localparam SPLAT  = 4'b0000; // splatted (all outputs zero)

    // State register
    reg [3:0] state, next_state;

    // Direction register: 0=left, 1=right
    reg dir, next_dir;

    // Fall count saturating counter (5 bits)
    reg [4:0] fall_count, next_fall_count;

    // Combined bump signal (bump on either or both sides)
    wire bump = bump_left | bump_right;

    // Asynchronous reset logic, initializes to walk left
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            dir <= 1'b0;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            fall_count <= next_fall_count;
        end
    end

    // Next state and direction combinational logic
    always @(*) begin
        // Default next state and direction is current state and direction
        next_state = state;
        next_dir = dir;
        next_fall_count = fall_count;

        case (state)
            WALK_L, WALK_R: begin
                // Extract walking direction from state
                // Determine next direction first (change on bump)
                if (!ground) begin
                    // No ground: start falling, fall_count=1, keep direction
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    // direction unchanged
                end else if (dig) begin
                    // Start digging, fall_count=0, direction unchanged
                    next_state = DIG;
                    next_fall_count = 5'd0;
                end else if (bump) begin
                    // Bumped, switch direction accordingly
                    // If bumped both sides same cycle, still reverse direction
                    next_dir = ~dir;
                    // Update walk state to corresponding new direction
                    next_state = (next_dir == 1'b0) ? WALK_L : WALK_R;
                    next_fall_count = 5'd0;
                end else begin
                    // No event, continue walking same direction
                    next_state = (dir == 1'b0) ? WALK_L : WALK_R;
                    next_fall_count = 5'd0;
                end
            end

            FALL: begin
                if (!ground) begin
                    // Continue falling, increment fall_count saturating at 31
                    next_state = FALL;
                    next_dir = dir;
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 5'd1 : fall_count;
                end else begin
                    // Landed: check splatter or walk
                    if (fall_count > 5'd20) begin
                        // splatter forever
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                        // direction irrelevant here, keep as is
                        next_dir = dir;
                    end else begin
                        // safe landing: resume walking same direction
                        next_state = (dir == 1'b0) ? WALK_L : WALK_R;
                        next_fall_count = 5'd0;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // ground lost: start falling, count=1
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    // direction unchanged
                    next_dir = dir;
                end else begin
                    // continue digging
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    next_dir = dir;
                end
            end

            SPLAT: begin
                // stay splatted forever; no outputs
                next_state = SPLAT;
                next_fall_count = 5'd0;
                next_dir = dir;
            end

            default: begin
                // Safe default to walk left
                next_state = WALK_L;
                next_dir = 1'b0;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Outputs derived from current state and direction
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule