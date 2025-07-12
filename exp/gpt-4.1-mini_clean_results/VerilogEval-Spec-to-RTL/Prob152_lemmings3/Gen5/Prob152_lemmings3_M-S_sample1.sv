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

    // State bits: [1] direction (0=left,1=right), [0] mode (0=walk,1=fall)
    // digging_reg independent flag set only when walking on ground and dig=1
    reg [1:0] state, next_state;
    reg digging_reg, next_digging;

    wire direction = state[1];
    wire falling   = state[0];

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // walk left, not falling
            digging_reg <= 1'b0;
        end else begin
            state <= next_state;
            digging_reg <= next_digging;
        end
    end

    // Next state and digging logic
    always @* begin
        // Defaults
        next_state = state;
        next_digging = digging_reg;

        if (falling) begin
            // Falling state
            next_digging = 1'b0; // no digging while falling
            if (ground) begin
                // Ground regained: resume walking with saved direction
                next_state = {direction, 1'b0};
                // digging remains off
            end else begin
                // Still falling
                next_state = state;
            end
        end else begin
            // Walking mode
            if (!ground) begin
                // Start falling, digging ends
                next_state = {direction, 1'b1};
                next_digging = 1'b0;
            end else if (digging_reg) begin
                // Continue digging until ground lost
                next_state = state; // direction and walking mode unchanged
                if (!ground) begin
                    // ground lost, start falling (covered above)
                    // this branch theoretically unreachable due to above if(!ground), 
                    // but keep for safety
                    next_state = {direction,1'b1};
                    next_digging = 1'b0;
                end else begin
                    // still digging
                    next_digging = 1'b1;
                end
            end else begin
                // Not falling and not digging
                // Check dig command
                if (dig) begin
                    next_digging = 1'b1;
                end else begin
                    next_digging = 1'b0;
                    // Check bumps to switch direction
                    if (bump_left || bump_right) begin
                        // Flip direction bit
                        next_state = {!direction, 1'b0};
                    end else begin
                        next_state = state; // stay
                    end
                end
            end
        end
    end

    // Outputs: walking direction only if walking and not digging
    assign walk_left  = (state == 2'b00) && !digging_reg; // direction=0, walk
    assign walk_right = (state == 2'b10) && !digging_reg; // direction=1, walk
    assign digging    = (!falling) && digging_reg;
    assign aaah       = falling;

endmodule