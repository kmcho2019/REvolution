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
localparam [2:0]
    WALK_LEFT  = 3'd0,
    WALK_RIGHT = 3'd1,
    FALL_LEFT  = 3'd2,
    FALL_RIGHT = 3'd3,
    DIG_LEFT   = 3'd4,
    DIG_RIGHT  = 3'd5,
    SPLATTER   = 3'd6;

reg [2:0] state, next_state;
reg [4:0] fall_counter;  // 5-bit counter for fall time (max 31 cycles)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 5'd0;
    end else begin
        state <= next_state;
        // Update fall_counter only in falling states
        if (state == FALL_LEFT || state == FALL_RIGHT) begin
            if (ground) begin
                // Reset counter on ground regain
                fall_counter <= 5'd0;
            end else begin
                fall_counter <= fall_counter + 1'b1;
            end
        end else begin
            fall_counter <= 5'd0;
        end
    end
end

// Determine next state (combinational)
always @* begin
    next_state = state; // default hold

    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                // Start falling left
                next_state = FALL_LEFT;
            end else if (dig) begin
                // Start digging left
                next_state = DIG_LEFT;
            end else if (bump_left || bump_right) begin
                // Bump - switch direction to right
                // Bumping on left or right or both causes switch
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                // Start falling right
                next_state = FALL_RIGHT;
            end else if (dig) begin
                // Start digging right
                next_state = DIG_RIGHT;
            end else if (bump_left || bump_right) begin
                // Switch direction to left
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end

        FALL_LEFT: begin
            if (ground) begin
                // On ground, check if splatter
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTER;
                end else begin
                    next_state = WALK_LEFT;
                end
            end else begin
                // Continue falling left
                next_state = FALL_LEFT;
            end
        end

        FALL_RIGHT: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTER;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = FALL_RIGHT;
            end
        end

        DIG_LEFT: begin
            if (!ground) begin
                // No ground while digging: start falling left
                next_state = FALL_LEFT;
            end else begin
                // Continue digging left, ignore bump or dig input
                next_state = DIG_LEFT;
            end
        end

        DIG_RIGHT: begin
            if (!ground) begin
                // Start falling right
                next_state = FALL_RIGHT;
            end else begin
                // Continue digging right
                next_state = DIG_RIGHT;
            end
        end

        SPLATTER: begin
            // Remain splattered forever until reset
            next_state = SPLATTER;
        end

        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Outputs depend only on current state (Moore)
always @* begin
    walk_left  = 1'b0;
    walk_right = 1'b0;
    aaah       = 1'b0;
    digging    = 1'b0;

    case(state)
        WALK_LEFT:  walk_left = 1'b1;
        WALK_RIGHT: walk_right = 1'b1;
        FALL_LEFT: begin
            aaah = 1'b1;
            // No walking or digging while falling
        end
        FALL_RIGHT: begin
            aaah = 1'b1;
        end
        DIG_LEFT:  digging = 1'b1;
        DIG_RIGHT: digging = 1'b1;
        SPLATTER: begin
            // all outputs zero
        end
    endcase
end

endmodule