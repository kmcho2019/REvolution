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
    typedef enum logic [2:0] {
        WALK_LEFT = 3'd0,
        WALK_RIGHT = 3'd1,
        FALLING_LEFT = 3'd2,
        FALLING_RIGHT = 3'd3,
        DIGGING_LEFT = 3'd4,
        DIGGING_RIGHT = 3'd5
    } state_t;

    state_t state, next_state;

    // Detect rising edge of ground to return from falling
    reg ground_d;
    always @(posedge clk or posedge areset) begin
        if (areset)
            ground_d <= 1'b1; // after reset assume ground present
        else
            ground_d <= ground;
    end

    // FSM next state logic
    always @(*) begin
        next_state = state; // default hold

        case(state)
            WALK_LEFT: begin
                // Priority: fall > dig > bump
                if (ground == 1'b0) begin
                    next_state = FALLING_LEFT;
                end else if (dig == 1'b1) begin
                    // start digging
                    next_state = DIGGING_LEFT;
                end else if (bump_left || bump_right) begin
                    // bump switches direction
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING_RIGHT;
                end else if (dig == 1'b1) begin
                    next_state = DIGGING_RIGHT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end

            FALLING_LEFT: begin
                // no bump or dig effect
                // If ground comes back, walk left
                if (ground == 1'b1 && ground_d == 1'b0) begin
                    next_state = WALK_LEFT;
                end
            end

            FALLING_RIGHT: begin
                if (ground == 1'b1 && ground_d == 1'b0) begin
                    next_state = WALK_RIGHT;
                end
            end

            DIGGING_LEFT: begin
                // Continue digging if ground
                if (ground == 1'b0) begin
                    // no ground => start falling left
                    next_state = FALLING_LEFT;
                end
                // no bump or dig effect
            end

            DIGGING_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING_RIGHT;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore)
    always @(*) begin
        // Default outputs
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
            FALLING_LEFT, FALLING_RIGHT: begin
                aaah = 1'b1;
            end
            DIGGING_LEFT: begin
                walk_left = 1'b1;
                digging = 1'b1;
            end
            DIGGING_RIGHT: begin
                walk_right = 1'b1;
                digging = 1'b1;
            end
        endcase
    end

endmodule