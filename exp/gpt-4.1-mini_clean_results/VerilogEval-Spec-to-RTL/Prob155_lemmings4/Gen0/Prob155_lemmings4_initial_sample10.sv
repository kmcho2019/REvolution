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
        WALK_LEFT    = 3'd0,
        WALK_RIGHT   = 3'd1,
        FALL_LEFT    = 3'd2,
        FALL_RIGHT   = 3'd3,
        DIG_LEFT     = 3'd4,
        DIG_RIGHT    = 3'd5,
        SPLATTERED   = 3'd6
    } state_t;

    reg [2:0] state, next_state;
    reg [4:0] fall_count; // counts from 0 to >20 (5 bits)

    // State register with async positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            // fall_count updates only in FALL states
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                if (ground == 1) // Falling ends here, reset counter next cycle
                    fall_count <= 5'd0;
                else
                    fall_count <= fall_count + 5'd1;
            end else begin
                fall_count <= 5'd0;
            end
        end
    end

    // Next state logic (Moore)
    always @(*) begin
        next_state = state; // default hold

        case(state)
            WALK_LEFT: begin
                if (ground == 1) begin
                    if (dig) begin
                        next_state = DIG_LEFT;
                    end else if (bump_left || bump_right) begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    // ground == 0 start falling
                    next_state = FALL_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1) begin
                    if (dig) begin
                        next_state = DIG_RIGHT;
                    end else if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                    end
                end else begin
                    // ground == 0 start falling
                    next_state = FALL_RIGHT;
                end
            end

            DIG_LEFT: begin
                if (ground == 0) begin
                    // No ground under digging means fall now
                    next_state = FALL_LEFT;
                end else begin
                    // continue digging
                    next_state = DIG_LEFT;
                end
            end

            DIG_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALL_RIGHT;
                end else begin
                    next_state = DIG_RIGHT;
                end
            end

            FALL_LEFT: begin
                if (ground == 1) begin
                    if (fall_count > 5'd20)
                        next_state = SPLATTERED;
                    else
                        next_state = WALK_LEFT;
                end else begin
                    // keep falling
                    next_state = FALL_LEFT;
                end
            end

            FALL_RIGHT: begin
                if (ground == 1) begin
                    if (fall_count > 5'd20)
                        next_state = SPLATTERED;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    // keep falling
                    next_state = FALL_RIGHT;
                end
            end

            SPLATTERED: begin
                // Remain splattered forever until reset
                next_state = SPLATTERED;
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore) based on current state
    always @(*) begin
        // Default all outputs zero
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
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
            FALL_LEFT, FALL_RIGHT: begin
                aaah = 1'b1;
            end
            SPLATTERED: begin
                // all outputs 0
            end
        endcase
    end

endmodule