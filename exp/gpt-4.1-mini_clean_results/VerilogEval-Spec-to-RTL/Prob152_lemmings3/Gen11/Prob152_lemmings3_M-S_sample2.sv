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

    reg [1:0] mode, next_mode;
    reg       dir, next_dir;

    // Next state logic for mode
    always @(*) begin
        // Default hold current mode and direction
        next_mode = mode;
        next_dir  = dir;

        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // fall has highest priority
                    next_mode = MODE_FALL;
                    // direction unchanged
                end else if (dig) begin
                    // start digging if dig requested on ground
                    next_mode = MODE_DIG;
                end else begin
                    // check bumps to change direction
                    if (bump_left && bump_right)
                        next_dir = ~dir;
                    else if (bump_left)
                        next_dir = 1'b1; // walk right
                    else if (bump_right)
                        next_dir = 1'b0; // walk left
                end
            end

            MODE_FALL: begin
                if (ground) begin
                    // land and resume walking same direction
                    next_mode = MODE_WALK;
                    // direction unchanged
                end
                // else remain falling, no direction change
            end

            MODE_DIG: begin
                if (!ground) begin
                    // ground gone, start falling, direction unchanged
                    next_mode = MODE_FALL;
                end
                // else continue digging, no direction change
            end

            default: begin
                // unknown mode, reset to walking left
                next_mode = MODE_WALK;
                next_dir = 1'b0;
            end
        endcase
    end

    // Sequential updates with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            dir  <= 1'b0; // walk left on reset
        end else begin
            mode <= next_mode;
            dir  <= next_dir;
        end
    end

    // Outputs
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule