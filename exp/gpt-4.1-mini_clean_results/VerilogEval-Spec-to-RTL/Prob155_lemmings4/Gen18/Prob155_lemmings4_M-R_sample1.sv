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
    localparam WALK  = 2'b00;
    localparam DIG   = 2'b01;
    localparam FALL  = 2'b10;
    localparam SPLAT = 2'b11;

    reg [1:0] state, next_state;
    reg       direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    wire bump_any = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;
    wire splat_condition = (fall_timer > 5'd20);

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state     <= WALK;
            direction <= 1'b0; // Walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state     <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SPLAT: next_state = SPLAT;

            FALL: begin
                if (ground) begin
                    if (splat_condition)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                end else begin
                    next_state = FALL;
                end
            end

            WALK: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else
                    next_state = WALK;
            end

            DIG: begin
                if (!ground)
                    next_state = FALL;
                else
                    next_state = DIG;
            end

            default: next_state = WALK;
        endcase
    end

    // Next direction logic
    always @(*) begin
        next_direction = direction;
        if (state == WALK) begin
            // Only switch direction if walking on ground and not falling or digging
            if (!(dig && ground)) begin // dig check is redundant here since state is WALK, but kept for clarity
                if (bump_both)
                    next_direction = ~direction;
                else if (bump_left)
                    next_direction = 1'b1; // walk right
                else if (bump_right)
                    next_direction = 1'b0; // walk left
            end
        end
        // During FALL and DIG states, direction doesn't change despite bumps
    end

    // Next fall_timer logic
    always @(*) begin
        if (state == FALL) begin
            if (ground)
                next_fall_timer = 5'd0;
            else
                next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
        end else begin
            next_fall_timer = 5'd0;
        end
    end

    // Output logic (Moore)
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule