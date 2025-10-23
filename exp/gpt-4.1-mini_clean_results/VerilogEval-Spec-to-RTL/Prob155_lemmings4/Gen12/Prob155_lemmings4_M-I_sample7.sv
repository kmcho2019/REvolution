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

    // States encoding
    localparam WALK  = 2'd0;
    localparam DIG   = 2'd1;
    localparam FALL  = 2'd2;
    localparam SPLAT = 2'd3;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    // State and fall_timer sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // start walking left
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Compute next_state and next_fall_timer only
    always @(*) begin
        next_state = state;
        next_fall_timer = 5'd0;

        case (state)
            SPLAT: begin
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    next_state = (fall_timer > 5'd20) ? SPLAT : WALK;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = FALL;
                    // Saturate increment at 31
                    next_fall_timer = (fall_timer < 5'd31) ? (fall_timer + 1) : 5'd31;
                end
            end

            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                end
            end

            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                end else begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                next_state = WALK;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Compute next_direction separately for clarity and speed
    always @(*) begin
        next_direction = direction; // default hold

        if (state == SPLAT) begin
            next_direction = direction; // no change
        end else if (state == FALL || state == DIG) begin
            // Direction doesn't change when falling or digging
            next_direction = direction;
        end else if (state == WALK) begin
            if (ground && !dig) begin
                if (bump_left && bump_right)
                    next_direction = ~direction; // toggle
                else if (bump_left)
                    next_direction = 1'b1; // walk right
                else if (bump_right)
                    next_direction = 1'b0; // walk left
                else
                    next_direction = direction;
            end else begin
                // During fall or dig start, direction doesn't change here
                next_direction = direction;
            end
        end else begin
            next_direction = direction;
        end
    end

    // Moore outputs
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule