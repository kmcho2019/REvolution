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

    reg [1:0] state, next_state;
    reg       direction, next_direction; // 0=left,1=right
    reg [4:0] fall_timer, next_fall_timer; // counts fall cycles

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;  // walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Direction update only when walking and bumped, else hold
    wire bump = bump_left | bump_right;
    wire both_bump = bump_left & bump_right;

    // Next state and fall_timer logic
    always @* begin
        // Defaults: hold values
        next_state      = state;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Stay splatted, no register toggling (hold)
                next_state      = SPLAT;
                next_fall_timer = fall_timer;
            end
            FALL: begin
                if (ground) begin
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = FALL;
                    // Saturate counter at 31
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
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
            default: begin
                next_state = WALK;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Direction update logic: only when WALK and bumped, else hold direction
    always @* begin
        next_direction = direction; // default hold

        if (state == WALK) begin
            if (bump) begin
                if (both_bump)
                    next_direction = ~direction;
                else if (bump_left)
                    next_direction = 1'b1;
                else if (bump_right)
                    next_direction = 1'b0;
            end
        end
    end

    // Outputs (Moore)
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule