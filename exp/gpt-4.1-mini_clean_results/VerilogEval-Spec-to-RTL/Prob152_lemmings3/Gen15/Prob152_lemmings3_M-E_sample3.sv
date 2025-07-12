module TopModule(
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

    // Mode encoding
    localparam MODE_WALK = 2'b00,
               MODE_FALL = 2'b01,
               MODE_DIG  = 2'b10;

    reg dir;           // 0=left, 1=right
    reg [1:0] mode;    // current mode

    // Next mode combinational logic
    reg [1:0] next_mode;
    reg next_dir;

    always @(*) begin
        // Default: hold current mode and direction
        next_mode = mode;
        next_dir = dir;

        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // Start falling on losing ground, keep direction
                    next_mode = MODE_FALL;
                end else if (dig) begin
                    // Start digging if dig=1 and walking on ground
                    next_mode = MODE_DIG;
                end else begin
                    // Change direction on bump if on ground and walking
                    if (bump_left && bump_right) begin
                        // both bumps flip direction
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        // bump left causes walk right
                        next_dir = 1'b1;
                    end else if (bump_right) begin
                        // bump right causes walk left
                        next_dir = 1'b0;
                    end
                    // else direction unchanged
                    next_mode = MODE_WALK;
                end
            end

            MODE_FALL: begin
                if (ground) begin
                    // Land, resume walking in same direction
                    next_mode = MODE_WALK;
                end else begin
                    // Keep falling
                    next_mode = MODE_FALL;
                end
                // Direction does not change when falling
                next_dir = dir;
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Digging ends on losing ground, start falling
                    next_mode = MODE_FALL;
                end else begin
                    // Keep digging
                    next_mode = MODE_DIG;
                end
                // Direction does not change while digging
                next_dir = dir;
            end

            default: begin
                // Recover from undefined mode: walk left
                next_mode = MODE_WALK;
                next_dir = 1'b0;
            end
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir <= 1'b0;         // walk left by default
            mode <= MODE_WALK;
        end else begin
            dir <= next_dir;
            mode <= next_mode;
        end
    end

    // Outputs decoding: Moore outputs depend only on current state
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule