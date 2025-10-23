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
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    // Combine bump signals once
    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // FSM registers with asynchronous reset
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

    // Next state and fall timer logic (simplified and prioritized)
    always @(*) begin
        // Default assignments
        next_state = state;
        next_fall_timer = 5'd0;

        case (state)
            SPLAT: begin
                next_state = SPLAT;
                next_fall_timer = 5'd0;
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
                    // Increment only if not saturated
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 1 : 5'd31;
                end
            end

            WALK: begin
                if (!ground) begin
                    // Fall has highest priority
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Digging if ground and dig asserted
                    next_state = DIG;
                end else begin
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Ground lost while digging => fall
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

    // Next direction logic: only changes in WALK state and only if bumped and not falling/digging
    always @(*) begin
        next_direction = direction;
        if (state == WALK) begin
            if (bump) begin
                if (bump_both)
                    next_direction = ~direction;   // Toggle if both bumps
                else if (bump_left)
                    next_direction = 1'b1;         // Walk right
                else
                    next_direction = 1'b0;         // Walk left
            end
        end
    end

    // Moore outputs derived from state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule