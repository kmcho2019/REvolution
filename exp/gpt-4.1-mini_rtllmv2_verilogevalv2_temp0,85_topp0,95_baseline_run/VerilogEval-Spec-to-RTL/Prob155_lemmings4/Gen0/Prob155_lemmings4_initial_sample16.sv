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
    typedef enum reg [2:0] {
        W_LEFT = 3'd0,
        W_RIGHT = 3'd1,
        F_LEFT = 3'd2,
        F_RIGHT = 3'd3,
        D_LEFT = 3'd4,
        D_RIGHT = 3'd5,
        SPLAT = 3'd6
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_count, next_fall_count;  // 5 bits to count up to at least 21

    // Sequential logic: state and fall_count
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= W_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Combinational next state and fall counter logic
    always @(*) begin
        // Default next state and fall count: hold current
        next_state = state;
        next_fall_count = fall_count;

        // Default outputs (not used here, output logic is Moore style below)
        // Evaluate transitions based on current state and inputs

        case(state)
            SPLAT: begin
                // Remain splattered forever until reset
                next_state = SPLAT;
                next_fall_count = fall_count; // irrelevant
            end

            // Walking states
            W_LEFT: begin
                if (ground == 1'b0) begin
                    // Fall starts
                    next_state = F_LEFT;
                    next_fall_count = 5'd1;
                end else if (dig == 1'b1) begin
                    // Start digging if on ground
                    next_state = D_LEFT;
                    next_fall_count = 5'd0;
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    // bump on either side switches direction (to right)
                    next_state = W_RIGHT;
                    next_fall_count = 5'd0;
                end else begin
                    // Keep walking left
                    next_state = W_LEFT;
                    next_fall_count = 5'd0;
                end
            end

            W_RIGHT: begin
                if (ground == 1'b0) begin
                    // Fall starts
                    next_state = F_RIGHT;
                    next_fall_count = 5'd1;
                end else if (dig == 1'b1) begin
                    // Start digging if on ground
                    next_state = D_RIGHT;
                    next_fall_count = 5'd0;
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    // bump on either side switches direction (to left)
                    next_state = W_LEFT;
                    next_fall_count = 5'd0;
                end else begin
                    // Keep walking right
                    next_state = W_RIGHT;
                    next_fall_count = 5'd0;
                end
            end

            // Falling states
            F_LEFT: begin
                if (ground == 1'b1) begin
                    // Landed on ground
                    if (fall_count > 5'd20) begin
                        // Splatter
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        // Resume walking left
                        next_state = W_LEFT;
                        next_fall_count = 5'd0;
                    end
                end else begin
                    // Still falling, increment counter
                    next_state = F_LEFT;
                    next_fall_count = fall_count + 5'd1;
                end
            end

            F_RIGHT: begin
                if (ground == 1'b1) begin
                    // Landed on ground
                    if (fall_count > 5'd20) begin
                        // Splatter
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        // Resume walking right
                        next_state = W_RIGHT;
                        next_fall_count = 5'd0;
                    end
                end else begin
                    // Still falling, increment counter
                    next_state = F_RIGHT;
                    next_fall_count = fall_count + 5'd1;
                end
            end

            // Digging states
            D_LEFT: begin
                if (ground == 1'b0) begin
                    // Digging ends, now falling left
                    next_state = F_LEFT;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging
                    next_state = D_LEFT;
                    next_fall_count = 5'd0;
                end
            end

            D_RIGHT: begin
                if (ground == 1'b0) begin
                    // Digging ends, now falling right
                    next_state = F_RIGHT;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging
                    next_state = D_RIGHT;
                    next_fall_count = 5'd0;
                end
            end

            default: begin
                // Should never happen, reset to walking left
                next_state = W_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Output logic (Moore FSM)
    always @(*) begin
        // Default outputs: all zero
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            W_LEFT: begin
                walk_left = 1'b1;
            end
            W_RIGHT: begin
                walk_right = 1'b1;
            end
            F_LEFT: begin
                aaah = 1'b1;
            end
            F_RIGHT: begin
                aaah = 1'b1;
            end
            D_LEFT: begin
                digging = 1'b1;
                walk_left = 1'b1; // Lemming is "on ground" and digging, so walking direction output also asserted
            end
            D_RIGHT: begin
                digging = 1'b1;
                walk_right = 1'b1;
            end
            SPLAT: begin
                // All zero outputs
            end
        endcase
    end

endmodule