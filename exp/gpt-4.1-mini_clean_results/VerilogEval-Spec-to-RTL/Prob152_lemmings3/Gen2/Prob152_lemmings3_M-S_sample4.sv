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

    always @(*) begin
        next_state = state;

        case(state)
            // Walking left
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;       // fall preserving direction
                end else if (dig) begin
                    next_state = DIG_LEFT;        // start digging left
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;      // bump switches direction
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            // Walking right
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

            // Falling left
            FALL_LEFT: begin
                if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALL_LEFT;
                end
            end

            // Falling right
            FALL_RIGHT: begin
                if (ground) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = FALL_RIGHT;
                end
            end

            // Digging left
            DIG_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;       // start falling left when ground lost
                end else begin
                    next_state = DIG_LEFT;        // continue digging
                end
            end

            // Digging right
            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else begin
                    next_state = DIG_RIGHT;
                end
            end

            default: begin
                next_state = WALK_LEFT;
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
            FALL_LEFT, FALL_RIGHT: begin
                aaah = 1;
            end
            DIG_LEFT: begin
                digging = 1;
                walk_left = 1;
            end
            DIG_RIGHT: begin
                digging = 1;
                walk_right = 1;
            end
        endcase
    end

endmodule