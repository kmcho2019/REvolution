module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    localparam WALK_LEFT  = 2'd0;
    localparam WALK_RIGHT = 2'd1;
    localparam FALL       = 2'd2;
    localparam DIG_LEFT   = 2'd3;
    // DIG_RIGHT uses same state encoding as DIG_LEFT with direction bit saved differently
    // Instead, we will distinguish DIG_LEFT and DIG_RIGHT by storing walk direction separately

    reg [1:0] state, next_state;
    reg prev_walk_left;  // 1 if walking left, 0 if walking right

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG_LEFT; // same DIG_LEFT state, use prev_walk_left=0 for direction
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALL: begin
                if (ground) begin
                    next_state = prev_walk_left ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALL;
                end
            end

            DIG_LEFT: begin
                if (!ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG_LEFT;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_left <= 1'b1;
        end else begin
            // Update previous walking direction only in walking states
            if (state == WALK_LEFT)
                prev_walk_left <= 1'b1;
            else if (state == WALK_RIGHT)
                prev_walk_left <= 1'b0;
            // Falling and digging do not change prev_walk_left

            state <= next_state;
        end
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1;
            end
            WALK_RIGHT: begin
                walk_right = 1;
            end
            FALL: begin
                aaah = 1;
            end
            DIG_LEFT: begin
                digging = 1;
                if (prev_walk_left)
                    walk_left = 1;
                else
                    walk_right = 1;
            end
        endcase
    end

endmodule