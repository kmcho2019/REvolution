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

    // State encoding: combine activity and direction in states
    localparam 
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT  = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT   = 3'd4,
        DIG_RIGHT  = 3'd5;

    reg [2:0] state, next_state;

    // Next state combinational logic with priority: fall > dig > bump
    always @(*) begin
        next_state = state; // default no change

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Fall preserving direction
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    // Start digging if dig asserted on ground while walking
                    next_state = DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end

            FALL_LEFT: begin
                if (ground) begin
                    // Land, resume walking left
                    next_state = WALK_LEFT;
                end
            end

            FALL_RIGHT: begin
                if (ground) begin
                    // Land, resume walking right
                    next_state = WALK_RIGHT;
                end
            end

            DIG_LEFT: begin
                if (!ground) begin
                    // Digging stops, start falling left
                    next_state = FALL_LEFT;
                end
                // else continue digging left
            end

            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end
                // else continue digging right
            end

            default: begin
                next_state = WALK_LEFT; // default reset/fallback
            end
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output decoding (Moore outputs from state)
    always @(*) begin
        // Defaults
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case(state)
            WALK_LEFT:  walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALL_LEFT,
            FALL_RIGHT: aaah = 1'b1;
            DIG_LEFT: begin
                digging = 1'b1;
                walk_left = 1'b1;
            end
            DIG_RIGHT: begin
                digging = 1'b1;
                walk_right = 1'b1;
            end
            default: walk_left = 1'b1; // safe default
        endcase
    end

endmodule