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

    // Next mode logic with priority: fall > dig > walk
    always @(*) begin
        if (!ground) begin
            // ground lost => falling regardless of current mode
            next_mode = MODE_FALL;
        end else begin
            case (mode)
                MODE_FALL: begin
                    // ground regained => resume walking
                    next_mode = MODE_WALK;
                end
                MODE_DIG: begin
                    if (!ground) begin
                        // start falling if ground lost (covered by outer if)
                        next_mode = MODE_FALL; // redundant but safe
                    end else begin
                        // continue digging if ground present
                        next_mode = MODE_DIG;
                    end
                end
                MODE_WALK: begin
                    // if dig requested while walking on ground, dig
                    if (dig && ground)
                        next_mode = MODE_DIG;
                    else
                        next_mode = MODE_WALK;
                end
                default: next_mode = MODE_WALK;
            endcase
        end
    end

    // Next direction logic (only updated when walking and ground present)
    always @(*) begin
        next_dir = dir; // default no change

        if (mode == MODE_WALK && ground) begin
            // Bump logic applies only in walking on ground
            if (bump_left && bump_right) begin
                next_dir = ~dir; // flip direction
            end else if (bump_left) begin
                next_dir = 1'b1; // walk right
            end else if (bump_right) begin
                next_dir = 1'b0; // walk left
            end
            // else no change
        end
        // else keep direction
    end

    // State register updates with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            dir  <= 1'b0; // walk left on reset
        end else begin
            mode <= next_mode;
            dir  <= next_dir;
        end
    end

    // Moore outputs
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule