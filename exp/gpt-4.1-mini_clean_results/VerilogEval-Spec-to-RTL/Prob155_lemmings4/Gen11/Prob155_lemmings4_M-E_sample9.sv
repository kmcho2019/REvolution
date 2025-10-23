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

    // One-hot states
    localparam WALK  = 4'b0001;
    localparam DIG   = 4'b0010;
    localparam FALL  = 4'b0100;
    localparam SPLAT = 4'b1000;

    reg [3:0] state, next_state;
    reg       direction, next_direction; // 0 = left, 1 = right
    reg [4:0] fall_counter, next_fall_counter;

    // State and direction registers with synchronous reset
    always @(posedge clk) begin
        if (areset) begin
            state        <= WALK;
            direction    <= 1'b0;      // start walking left
            fall_counter <= 5'd0;
        end else begin
            state        <= next_state;
            direction    <= next_direction;
            fall_counter <= next_fall_counter;
        end
    end

    // Combinational next state logic and outputs
    always @* begin
        // Default assignments to hold current values
        next_state        = state;
        next_direction    = direction;
        next_fall_counter = fall_counter;

        // Walking bump direction update condition
        // If bumped left -> walk right; bumped right -> walk left
        // Both bumps -> toggle direction
        // This only applies during WALK state and ground=1 and not falling or digging

        case(state)
            SPLAT: begin
                // Remain splatted forever
                next_state        = SPLAT;
                next_fall_counter = 5'd0;
                // direction unchanged
            end

            FALL: begin
                if (ground) begin
                    // Landed after falling
                    if (fall_counter > 5'd20)
                        next_state = SPLAT;  // splatter and stop
                    else
                        next_state = WALK;   // resume walking same direction
                    next_fall_counter = 5'd0;
                    // direction unchanged
                end else begin
                    next_state = FALL;
                    // Increment fall timer saturating at max 31
                    next_fall_counter = (fall_counter == 5'd31) ? 5'd31 : fall_counter + 1'b1;
                    // direction unchanged
                end
            end

            DIG: begin
                if (!ground) begin
                    // Fell off digging edge, start falling
                    next_state = FALL;
                    next_fall_counter = 5'd1;
                    // direction unchanged
                end else begin
                    next_state = DIG;
                    next_fall_counter = 5'd0;
                    // direction unchanged
                end
            end

            WALK: begin
                if (!ground) begin
                    // Start falling
                    next_state = FALL;
                    next_fall_counter = 5'd1;
                    // direction unchanged
                end else if (dig) begin
                    // Start digging if on ground
                    next_state = DIG;
                    next_fall_counter = 5'd0;
                    // direction unchanged
                end else begin
                    // Continue walking
                    next_state = WALK;
                    next_fall_counter = 5'd0;

                    // Update direction on bumps
                    if (bump_left & bump_right)
                        next_direction = ~direction; // toggle
                    else if (bump_left)
                        next_direction = 1'b1;        // walk right
                    else if (bump_right)
                        next_direction = 1'b0;        // walk left
                    else
                        next_direction = direction;   // no change
                end
            end

            default: begin
                // Should not happen; reset to safe state
                next_state        = WALK;
                next_direction    = 1'b0;
                next_fall_counter = 5'd0;
            end
        endcase
    end

    // Output logic: Moore outputs based on state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule