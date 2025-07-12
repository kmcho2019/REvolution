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

    localparam MODE_WALK  = 2'd0;
    localparam MODE_DIG   = 2'd1;
    localparam MODE_FALL  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer; // counts up to 21 saturating

    // Async posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0; // walk left
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
        next_fall_timer = fall_timer;

        case (mode)
            MODE_SPLAT: begin
                // stay splatted forever, outputs zero
            end

            MODE_FALL: begin
                if (ground) begin
                    // Landed
                    next_mode = (fall_timer > 5'd20) ? MODE_SPLAT : MODE_WALK;
                    next_fall_timer = 5'd0;
                    // direction unchanged
                end else begin
                    // increment timer saturating at 21
                    next_fall_timer = (fall_timer < 5'd21) ? fall_timer + 1'b1 : 5'd21;
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_mode = MODE_DIG;
                end else if (bump_left || bump_right) begin
                    // switch direction on bump
                    next_direction = ~direction;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    next_mode = MODE_FALL;
                    next_fall_timer = 5'd1;
                end
                // continue digging otherwise
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule