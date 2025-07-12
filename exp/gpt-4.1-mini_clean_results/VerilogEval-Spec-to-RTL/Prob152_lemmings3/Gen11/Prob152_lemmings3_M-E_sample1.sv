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

    // Mode encoding
    localparam MODE_WALK = 2'b00;
    localparam MODE_FALL = 2'b01;
    localparam MODE_DIG  = 2'b10;

    reg dir;         // 0=left, 1=right
    reg [1:0] mode;  // walking, falling, digging

    reg next_dir;
    reg [1:0] next_mode;

    always @(*) begin
        // Default: stay in current state
        next_mode = mode;
        next_dir = dir;

        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // Ground lost: start falling, keep direction
                    next_mode = MODE_FALL;
                    // direction unchanged
                end else if (dig) begin
                    // Start digging if on ground and dig=1
                    next_mode = MODE_DIG;
                    // direction unchanged
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump, walking only
                    // If both bumps, flip direction
                    if (bump_left && bump_right) begin
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        next_dir = 1'b1; // walk right
                    end else begin
                        next_dir = 1'b0; // walk left
                    end
                    // mode unchanged (walking)
                end
                // else remain walking same direction
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed: resume walking same direction
                    next_mode = MODE_WALK;
                end
                // else keep falling; bumps and dig ignored while falling
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Dig ended due to fall; start falling same direction
                    next_mode = MODE_FALL;
                end
                // else keep digging; bumps ignored
            end

            default: begin
                // safe fallback: walk left
                next_mode = MODE_WALK;
                next_dir = 1'b0;
            end
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir <= 1'b0;         // walk left
            mode <= MODE_WALK;
        end else begin
            dir <= next_dir;
            mode <= next_mode;
        end
    end

    // Outputs as Moore outputs depending on mode and dir
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule