module TopModule (
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
    typedef enum reg [2:0] {
        WALK_LEFT   = 3'd0,
        WALK_RIGHT  = 3'd1,
        FALLING_LEFT  = 3'd2,
        FALLING_RIGHT = 3'd3,
        DIGGING_LEFT  = 3'd4,
        DIGGING_RIGHT = 3'd5,
        SPLATTERED  = 3'd6
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_count; // 5-bit counter to count up to >20

    // Determine next state
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    // fall left
                    next_state = FALLING_LEFT;
                end else if (dig == 1) begin
                    // start digging left
                    next_state = DIGGING_LEFT;
                end else begin
                    // bump checking
                    // if bumped left or bumped right => walk right
                    if (bump_left || bump_right)
                        next_state = WALK_RIGHT;
                    else
                        next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 0) begin
                    // fall right
                    next_state = FALLING_RIGHT;
                end else if (dig == 1) begin
                    // start digging right
                    next_state = DIGGING_RIGHT;
                end else begin
                    // bump checking
                    // if bumped left or bumped right => walk left
                    if (bump_left || bump_right)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end
            end

            FALLING_LEFT: begin
                if (ground == 1) begin
                    // on ground, check fall count for splatter or walk left
                    if (fall_count > 5'd20)
                        next_state = SPLATTERED;
                    else
                        next_state = WALK_LEFT;
                end else begin
                    // continue falling left
                    next_state = FALLING_LEFT;
                end
            end

            FALLING_RIGHT: begin
                if (ground == 1) begin
                    if (fall_count > 5'd20)
                        next_state = SPLATTERED;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    // continue falling right
                    next_state = FALLING_RIGHT;
                end
            end

            DIGGING_LEFT: begin
                if (ground == 0) begin
                    // no ground now, start falling left
                    next_state = FALLING_LEFT;
                end else begin
                    // continue digging left
                    next_state = DIGGING_LEFT;
                end
            end

            DIGGING_RIGHT: begin
                if (ground == 0) begin
                    // no ground now, start falling right
                    next_state = FALLING_RIGHT;
                end else begin
                    // continue digging right
                    next_state = DIGGING_RIGHT;
                end
            end

            SPLATTERED: begin
                // remain splattered forever until reset
                next_state = SPLATTERED;
            end

            default: begin
                // default fallback to WALK_LEFT
                next_state = WALK_LEFT;
            end
        endcase
    end

    // State register and fall count update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            // update fall_count
            if (next_state == FALLING_LEFT || next_state == FALLING_RIGHT) begin
                if (state == next_state)
                    fall_count <= fall_count + 5'd1;
                else
                    fall_count <= 5'd1; // just started falling
            end else begin
                fall_count <= 5'd0;
            end
        end
    end

    // Moore outputs
    always @(*) begin
        // default outputs
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
            FALLING_LEFT: begin
                aaah = 1;
            end
            FALLING_RIGHT: begin
                aaah = 1;
            end
            DIGGING_LEFT: begin
                digging = 1;
                walk_left = 1;
            end
            DIGGING_RIGHT: begin
                digging = 1;
                walk_right = 1;
            end
            SPLATTERED: begin
                // all outputs 0
            end
        endcase
    end
endmodule