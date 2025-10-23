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

    // State encoding
    localparam WALK  = 2'd0;
    localparam DIG   = 2'd1;
    localparam FALL  = 2'd2;
    localparam SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= WALK;
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
        next_fall_timer = (mode == FALL && !ground && fall_timer < 5'd31) ? fall_timer + 1 : 5'd0;

        case (mode)
            SPLAT: begin
                // remain splatted
            end

            FALL: begin
                if (ground) begin
                    if (fall_timer > 5'd20)
                        next_mode = SPLAT;
                    else
                        next_mode = WALK;
                end
                // else continue falling with fall_timer increment handled above
            end

            WALK: begin
                if (!ground) begin
                    next_mode = FALL;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_mode = DIG;
                end else if (bump_left || bump_right) begin
                    // reverse direction if bumped on either or both sides
                    next_direction = ~direction;
                end
            end

            DIG: begin
                if (!ground) begin
                    next_mode = FALL;
                    next_fall_timer = 5'd1;
                end
            end
        endcase
    end

    assign walk_left  = (mode == WALK) && (direction == 1'b0);
    assign walk_right = (mode == WALK) && (direction == 1'b1);
    assign aaah       = (mode == FALL);
    assign digging    = (mode == DIG);

endmodule