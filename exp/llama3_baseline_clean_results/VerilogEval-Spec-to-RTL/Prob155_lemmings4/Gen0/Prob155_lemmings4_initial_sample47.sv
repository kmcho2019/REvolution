module TopModule (
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

    // Define states
    enum logic [3:0] {
        WALKING_LEFT,
        WALKING_RIGHT,
        FALLING,
        DIGGING,
        SPLATTERED
    } state, next_state;

    // Define counter
    logic [5:0] fall_counter;

    // Sequential logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING_LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            if (state == FALLING) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Combinational logic
    always_comb begin
        case (state)
            WALKING_LEFT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left == 1) begin
                    next_state = WALKING_RIGHT;
                end else if (bump_right == 1 && dig == 0) begin
                    next_state = WALKING_RIGHT;
                end else if (dig == 1) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALKING_LEFT;
                end
            end
            WALKING_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_right == 1) begin
                    next_state = WALKING_LEFT;
                end else if (bump_left == 1 && dig == 0) begin
                    next_state = WALKING_LEFT;
                end else if (dig == 1) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALKING_RIGHT;
                end
            end
            FALLING: begin
                if (ground == 1) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTERED;
                    end else begin
                        if (state == FALLING) begin
                            next_state = WALKING_LEFT;
                        end else if (state == DIGGING) begin
                            next_state = WALKING_RIGHT;
                        end else begin
                            next_state = WALKING_LEFT;
                        end
                    end
                end else begin
                    next_state = FALLING;
                end
            end
            DIGGING: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            SPLATTERED: begin
                next_state = SPLATTERED;
            end
            default: begin
                next_state = WALKING_LEFT;
            end
        endcase
    end

    // Output logic
    always_comb begin
        case (state)
            WALKING_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
            WALKING_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
            end
            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end
            DIGGING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end
            SPLATTERED: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
            default: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule