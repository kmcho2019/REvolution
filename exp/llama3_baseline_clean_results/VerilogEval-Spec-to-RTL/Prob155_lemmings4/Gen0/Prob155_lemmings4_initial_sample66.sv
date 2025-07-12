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

    // Define the states
    enum logic [2:0] {
        IDLE_LEFT,
        IDLE_RIGHT,
        FALLING,
        DIGGING,
        SPLATTERED
    } state, next_state;

    // Counter to track the number of clock cycles the Lemming has been falling
    logic [5:0] fall_counter;

    // Output logic
    always_comb begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (state)
            IDLE_LEFT: begin
                walk_left = 1;
            end
            IDLE_RIGHT: begin
                walk_right = 1;
            end
            FALLING: begin
                aaah = 1;
            end
            DIGGING: begin
                digging = 1;
            end
            default: ;
        endcase
    end

    // Next state logic
    always_comb begin
        next_state = state;

        case (state)
            IDLE_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = IDLE_RIGHT;
                end else if (bump_right) begin
                    next_state = IDLE_LEFT;
                end
            end
            IDLE_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = IDLE_LEFT;
                end else if (bump_right) begin
                    next_state = IDLE_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = (state == IDLE_LEFT) ? IDLE_LEFT : IDLE_RIGHT;
                    end
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            SPLATTERED: begin
                next_state = SPLATTERED;
            end
            default: ;
        endcase
    end

    // Sequential logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE_LEFT;
            fall_counter <= 0;
        end else begin
            case (state)
                FALLING: begin
                    fall_counter <= fall_counter + 1;
                end
                default: begin
                    fall_counter <= 0;
                end
            endcase
            state <= next_state;
        end
    end

endmodule