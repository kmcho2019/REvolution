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

    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    wire bump = bump_left | bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0; // start walking left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        next_mode = mode;
        next_direction = direction;
        next_fall_timer = 5'd0;

        case (mode)
            MODE_SPLAT: begin
                next_mode = MODE_SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
            end

            MODE_FALL: begin
                if (ground) begin
                    if (fall_timer > 5'd20)
                        next_mode = MODE_SPLAT;
                    else
                        next_mode = MODE_WALK;
                    next_direction = direction;
                    next_fall_timer = 5'd0;
                end else begin
                    next_mode = MODE_FALL;
                    next_direction = direction;
                    next_fall_timer = (fall_timer < 5'd31) ? (fall_timer + 1'b1) : fall_timer;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else if (bump) begin
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    if (bump_left && bump_right)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1; // walk right
                    else // bump_right only
                        next_direction = 1'b0; // walk left
                end else begin
                    next_mode = MODE_WALK;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    next_mode = MODE_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            default: begin
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule