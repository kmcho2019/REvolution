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

    // States encode behavior only
    localparam WALK = 2'd0;
    localparam FALL = 2'd1;
    localparam DIG  = 2'd2;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0 = left, 1 = right

    // Sequential logic: state and direction with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // start walking left
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Next-state and direction logic with priority: fall > dig > bump switch
    always @(*) begin
        // Default to current state/direction
        next_state = state;
        next_direction = direction;

        case(state)
            WALK: begin
                if (!ground) begin
                    // Fall, preserve direction
                    next_state = FALL;
                end else if (dig) begin
                    // Start digging if dig=1 and on ground walking
                    next_state = DIG;
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump when walking on ground
                    // Both bump_left and bump_right high also triggers switch
                    next_direction = ~direction;
                end
                // else remain walking, same direction
            end
            DIG: begin
                if (!ground) begin
                    // Ground gone, start falling, preserve direction
                    next_state = FALL;
                end
                // else continue digging, ignore bumps
            end
            FALL: begin
                if (ground) begin
                    // Landed, resume walking with same direction
                    next_state = WALK;
                end
                // else remain falling, ignore bumps and dig
            end
            default: begin
                next_state = WALK;
                next_direction = 1'b0;
            end
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            WALK: begin
                if (direction == 1'b0)
                    walk_left = 1;
                else
                    walk_right = 1;
            end
            DIG: begin
                digging = 1;
                if (direction == 1'b0)
                    walk_left = 1;
                else
                    walk_right = 1;
            end
            FALL: begin
                aaah = 1;
                // No walking outputs during fall
            end
            default: begin
                // Safety default: no outputs
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule