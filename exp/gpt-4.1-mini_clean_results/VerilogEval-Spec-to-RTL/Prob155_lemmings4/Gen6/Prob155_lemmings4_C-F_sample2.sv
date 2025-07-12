module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
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

    // Packed state register: [2]=direction (0=left,1=right), [1:0]=state/mode
    reg [2:0] state_dir, next_state_dir;

    // 5-bit saturating fall counter
    reg [4:0] fall_count, next_fall_count;

    // Extract current state and direction
    wire [1:0] state = state_dir[1:0];
    wire direction = state_dir[2];

    // Combine bump signals for clarity
    wire bump_both = bump_left & bump_right;
    wire bump_only_left = bump_left & ~bump_right;
    wire bump_only_right = bump_right & ~bump_left;

    // Combinational next state and fall count logic
    always @(*) begin
        // Default: hold current state and fall_count
        next_state_dir = state_dir;
        next_fall_count = fall_count;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Ground disappeared: start falling with count=1
                    next_state_dir[1:0] = FALL;
                    next_fall_count = 5'd1;
                    // direction unchanged
                    next_state_dir[2] = direction;
                end else if (dig) begin
                    // Dig command while walking on ground: start digging
                    next_state_dir[1:0] = DIG;
                    next_fall_count = 5'd0;
                    next_state_dir[2] = direction;
                end else begin
                    // Walking on ground, handle bumps with priority
                    next_state_dir[1:0] = WALK;
                    next_fall_count = 5'd0;
                    if (bump_both) begin
                        // bump both sides: toggle direction
                        next_state_dir[2] = ~direction;
                    end else if (bump_only_left) begin
                        // bump left: walk right
                        next_state_dir[2] = 1'b1;
                    end else if (bump_only_right) begin
                        // bump right: walk left
                        next_state_dir[2] = 1'b0;
                    end else begin
                        // no bump: keep direction
                        next_state_dir[2] = direction;
                    end
                end
            end

            FALL: begin
                if (!ground) begin
                    // Continue falling, increment fall_count saturate at 31
                    next_state_dir[1:0] = FALL;
                    next_state_dir[2] = direction;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 5'd1;
                    else
                        next_fall_count = fall_count;
                end else begin
                    // Landed on ground: splatter if fallen too long, else walk
                    if (fall_count > 5'd20) begin
                        next_state_dir[1:0] = SPLAT;
                        next_fall_count = 5'd0;
                        next_state_dir[2] = direction; // direction retained but irrelevant
                    end else begin
                        next_state_dir[1:0] = WALK;
                        next_fall_count = 5'd0;
                        next_state_dir[2] = direction;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // Ground disappeared while digging: start falling with count=1
                    next_state_dir[1:0] = FALL;
                    next_fall_count = 5'd1;
                    next_state_dir[2] = direction;
                end else begin
                    // Continue digging on ground
                    next_state_dir[1:0] = DIG;
                    next_fall_count = 5'd0;
                    next_state_dir[2] = direction;
                end
            end

            SPLAT: begin
                // Remain splatted forever, all outputs 0
                next_state_dir[1:0] = SPLAT;
                next_fall_count = 5'd0;
                next_state_dir[2] = direction;
            end

            default: begin
                // Defensive reset to walking left
                next_state_dir = {1'b0, WALK};
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Sequential logic with asynchronous posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_dir <= {1'b0, WALK};  // walk left on reset
            fall_count <= 5'd0;
        end else begin
            state_dir <= next_state_dir;
            fall_count <= next_fall_count;
        end
    end

    // Moore outputs from current state_dir
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule