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

    // Mode encoding
    localparam MODE_WALK = 2'b00,
               MODE_FALL = 2'b01,
               MODE_DIG  = 2'b10;

    reg [1:0] mode;
    reg       dir;  // 0 = left, 1 = right

    // Next state signals
    reg [1:0] next_mode;
    reg       next_dir;

    always @(*) begin
        // Default next state assignments
        next_mode = mode;
        next_dir  = dir;

        // Priority: falling > digging > direction change
        case(mode)
            MODE_WALK: begin
                // Falling has highest priority
                if (!ground)
                    next_mode = MODE_FALL;
                // Digging second priority, only if on ground and dig asserted
                else if (dig)
                    next_mode = MODE_DIG;
                else begin
                    // Check bump conditions for direction change
                    if (bump_left || bump_right) begin
                        // If bumped both sides, invert direction
                        if (bump_left && bump_right)
                            next_dir = ~dir;
                        else if (bump_left)
                            next_dir = 1'b1; // walk right
                        else
                            next_dir = 1'b0; // walk left
                    end
                    // mode stays walk, dir updated above if needed
                end
            end

            MODE_FALL: begin
                // Stay in fall while no ground
                if (ground)
                    next_mode = MODE_WALK; // resume walking same dir
                // else stay falling, dir unchanged
            end

            MODE_DIG: begin
                // If ground disappears while digging, start falling
                if (!ground)
                    next_mode = MODE_FALL;
                // else keep digging
            end

            default: begin
                // default safe fallback to walking left
                next_mode = MODE_WALK;
                next_dir = 1'b0;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            dir  <= 1'b0; // walk left on reset
        end else begin
            mode <= next_mode;
            dir  <= next_dir;
        end
    end

    // Outputs decoded from current mode and dir
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule