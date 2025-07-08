module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    localparam WALK_LEFT    = 3'd0;
    localparam WALK_RIGHT   = 3'd1;
    localparam DIG_LEFT     = 3'd2;
    localparam DIG_RIGHT    = 3'd3;
    localparam FALLING_LEFT = 3'd4;
    localparam FALLING_RIGHT= 3'd5;
    localparam SPLATTER     = 3'd6;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter; // counts up to >20 (5 bits enough for 31)

    // Async reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 5'd0;
        end else begin
            state <= next_state;
            if (next_state == FALLING_LEFT || next_state == FALLING_RIGHT) begin
                if (state == FALLING_LEFT || state == FALLING_RIGHT)
                    fall_counter <= fall_counter + 1'b1;
                else
                    fall_counter <= 5'd1; // start counting at 1 on entering falling
            end else begin
                fall_counter <= 5'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case (state)
            SPLATTER: begin
                // Forever splattered until reset
                next_state = SPLATTER;
            end

            FALLING_LEFT, FALLING_RIGHT: begin
                if (ground) begin
                    // Hit ground while falling
                    if (fall_counter > 5'd20) begin
                        next_state = SPLATTER;
                    end else begin
                        // Return to walking same direction
                        if (state == FALLING_LEFT)
                            next_state = WALK_LEFT;
                        else
                            next_state = WALK_RIGHT;
                    end
                end else begin
                    // Continue falling
                    next_state = state;
                end
            end

            DIG_LEFT: begin
                if (!ground) begin
                    // ground lost during digging -> fall
                    next_state = FALLING_LEFT;
                end else if (!dig) begin
                    // stop digging if dig=0 on ground
                    next_state = WALK_LEFT;
                end else begin
                    // continue digging
                    next_state = DIG_LEFT;
                end
            end

            DIG_RIGHT: begin
                if (!ground) begin
                    // ground lost during digging -> fall
                    next_state = FALLING_RIGHT;
                end else if (!dig) begin
                    // stop digging if dig=0 on ground
                    next_state = WALK_RIGHT;
                end else begin
                    // continue digging
                    next_state = DIG_RIGHT;
                end
            end

            WALK_LEFT: begin
                if (!ground) begin
                    // fall
                    next_state = FALLING_LEFT;
                end else if (dig) begin
                    // start digging
                    next_state = DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    // switch to walk right on any bump
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    // fall
                    next_state = FALLING_RIGHT;
                end else if (dig) begin
                    // start digging
                    next_state = DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    // switch to walk left on any bump
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            default: begin
                // Should not occur, but default to WALK_LEFT
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        // Defaults all zero
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end

            WALK_RIGHT: begin
                walk_right = 1'b1;
            end

            DIG_LEFT: begin
                walk_left = 1'b1;
                digging = 1'b1;
            end

            DIG_RIGHT: begin
                walk_right = 1'b1;
                digging = 1'b1;
            end

            FALLING_LEFT,
            FALLING_RIGHT: begin
                aaah = 1'b1;
            end

            SPLATTER: begin
                // all zero, no output
            end

            default: begin
                // no output
            end
        endcase
    end

endmodule