module TopModule(
    input clk,
    input areset,       // asynchronous posedge reset
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (binary)
    localparam WALK = 2'b00;
    localparam DIG  = 2'b01;
    localparam FALL = 2'b10;
    localparam SPLAT= 2'b11;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0 = left, 1 = right

    reg [4:0] fall_timer, next_fall_timer;

    // Asynchronous reset and sequential state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0; // walk left initially
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Combinational next state logic
    always @(*) begin
        // Defaults to current values
        next_state      = state;
        next_direction  = direction;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Once splatted, remain splatted forever
                next_state = SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    // Landed on ground after fall
                    if (fall_timer > 5'd20) begin
                        next_state = SPLAT; // splat if fall too long
                        next_fall_timer = 5'd0;
                    end else begin
                        next_state = WALK; // resume walking same direction
                        next_fall_timer = 5'd0;
                    end
                    next_direction = direction; // direction unchanged while falling
                end else begin
                    // Still falling, increment fall timer saturating at 31
                    next_state = FALL;
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 1 : 5'd31;
                    next_direction = direction; // no change
                end
            end

            DIG: begin
                if (!ground) begin
                    // Ground disappeared while digging: start falling
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction; // direction retained
                end else begin
                    // Continue digging
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            WALK: begin
                if (!ground) begin
                    // Start falling
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction; // direction retained
                end else if (dig) begin
                    // Start digging
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Continue walking, possibly change direction on bump
                    next_state = WALK;
                    next_fall_timer = 5'd0;

                    if (bump_left && bump_right) begin
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        next_direction = 1'b1; // walk right
                    end else if (bump_right) begin
                        next_direction = 1'b0; // walk left
                    end else begin
                        next_direction = direction; // no change
                    end
                end
            end

            default: begin
                // Safety fallback: go to WALK state walking left
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule