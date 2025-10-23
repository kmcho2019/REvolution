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
    localparam WALK_LEFT  = 3'd0;
    localparam WALK_RIGHT = 3'd1;
    localparam FALL_LEFT  = 3'd2;
    localparam FALL_RIGHT = 3'd3;
    localparam DIG_LEFT   = 3'd4;
    localparam DIG_RIGHT  = 3'd5;

    reg [2:0] state, next_state;

    // State register with async reset (posedge areset)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        // Default next_state is current state
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Fall takes precedence
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    // switch direction if bumped on either side
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALL_LEFT: begin
                // bump and dig ignored while falling
                if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALL_LEFT;
                end
            end

            FALL_RIGHT: begin
                if (ground) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = FALL_RIGHT;
                end
            end

            DIG_LEFT: begin
                if (!ground) begin
                    // start falling when reach edge
                    next_state = FALL_LEFT;
                end else begin
                    // continue digging
                    next_state = DIG_LEFT;
                end
            end

            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else begin
                    next_state = DIG_RIGHT;
                end
            end

            default: begin
                // safe default to WALK_LEFT
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Outputs depend only on state (Moore)
    always @(*) begin
        // Defaults
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALL_LEFT: begin
                aaah = 1'b1;
            end
            FALL_RIGHT: begin
                aaah = 1'b1;
            end
            DIG_LEFT: begin
                walk_left = 1'b1;
                digging = 1'b1;
            end
            DIG_RIGHT: begin
                walk_right = 1'b1;
                digging = 1'b1;
            end
        endcase
    end

endmodule