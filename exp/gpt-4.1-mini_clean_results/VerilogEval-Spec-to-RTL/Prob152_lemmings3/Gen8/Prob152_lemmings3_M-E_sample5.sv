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

    // Modes encoding
    localparam MODE_WALK = 2'd0;
    localparam MODE_FALL = 2'd1;
    localparam MODE_DIG  = 2'd2;

    reg mode, next_mode;
    reg [1:0] mode_r, mode_n;
    reg direction_r, direction_n; // 0 = left, 1 = right

    // Registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode_r <= MODE_WALK;
            direction_r <= 1'b0; // walk left on reset
        end else begin
            mode_r <= mode_n;
            direction_r <= direction_n;
        end
    end

    // Next state logic
    always @(*) begin
        // Default next states keep current values
        mode_n = mode_r;
        direction_n = direction_r;

        // Only update direction when walking and bumped, bumps ignored otherwise
        if (mode_r == MODE_WALK) begin
            // If bumped on left, walk right; if bumped on right, walk left; if both bumps, still flip direction
            if (bump_left && bump_right) begin
                direction_n = ~direction_r;
            end else if (bump_left) begin
                direction_n = 1'b1; // walk right
            end else if (bump_right) begin
                direction_n = 1'b0; // walk left
            end else begin
                direction_n = direction_r; // no change
            end
        end else begin
            // Direction held constant while falling or digging
            direction_n = direction_r;
        end

        // Mode transitions with precedence: fall > dig > walk direction changes
        if (ground == 1'b0 && mode_r != MODE_FALL) begin
            // ground lost, start falling regardless of current mode except already falling
            mode_n = MODE_FALL;
        end else if (mode_r == MODE_FALL) begin
            // ground regained, resume walking in same direction
            if (ground == 1'b1)
                mode_n = MODE_WALK;
            else
                mode_n = MODE_FALL;
        end else if (mode_r == MODE_WALK) begin
            // On ground and walking, can start digging if dig=1
            if (dig == 1'b1)
                mode_n = MODE_DIG;
            else
                mode_n = MODE_WALK;
        end else if (mode_r == MODE_DIG) begin
            // While digging, if ground lost, switch to falling
            if (ground == 1'b0)
                mode_n = MODE_FALL;
            else
                mode_n = MODE_DIG;
        end else begin
            mode_n = mode_r; // default hold mode
        end
    end

    assign walk_left  = (mode_r == MODE_WALK) && (direction_r == 1'b0);
    assign walk_right = (mode_r == MODE_WALK) && (direction_r == 1'b1);
    assign aaah       = (mode_r == MODE_FALL);
    assign digging    = (mode_r == MODE_DIG);

endmodule