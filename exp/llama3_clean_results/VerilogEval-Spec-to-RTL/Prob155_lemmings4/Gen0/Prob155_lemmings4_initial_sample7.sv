module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// State enum
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALL = 3'b011,
    DIG = 3'b100,
    SPLAT = 3'b000
} state, next_state;

// Counters
reg [5:0] fall_counter;
reg [5:0] dig_counter;

// Combinational logic for next state and outputs
always_comb begin
    // Default values
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // Already walking left
            end
            walk_left = 1;
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                // Already walking right
            end
            walk_right = 1;
        end
        FALL: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLAT;
                end else begin
                    // Resume walking in the same direction
                    if (dig_counter == 0) begin
                        if (bump_left) begin
                            next_state = WALK_RIGHT;
                        end else if (bump_right) begin
                            next_state = WALK_LEFT;
                        end else begin
                            next_state = state == WALK_LEFT ? WALK_LEFT : WALK_RIGHT;
                        end
                    end else begin
                        // Resume walking in the original direction after digging
                        next_state = dig_counter % 2 == 0 ? WALK_LEFT : WALK_RIGHT;
                    end
                end
            end
            aaah = 1;
        end
        DIG: begin
            if (~ground) begin
                next_state = FALL;
                dig_counter = 0;
            end
            digging = 1;
        end
        SPLAT: begin
            // Do nothing
        end
    endcase
end

// Sequential logic for state and counters
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
        dig_counter <= 0;
    end else begin
        state <= next_state;
        if (state == FALL) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
        if (state == DIG) begin
            dig_counter <= dig_counter + 1;
        end else begin
            dig_counter <= 0;
        end
    end
end

endmodule