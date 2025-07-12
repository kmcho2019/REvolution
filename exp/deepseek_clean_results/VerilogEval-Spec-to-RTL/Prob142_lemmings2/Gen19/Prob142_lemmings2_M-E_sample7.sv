module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // Walking direction state machine
    typedef enum {LEFT, RIGHT} walk_state_t;
    walk_state_t walk_state, next_walk_state;

    // Falling state machine
    typedef enum {GROUNDED, FALLING} fall_state_t;
    fall_state_t fall_state, next_fall_state;

    // Walking direction FSM
    always @(*) begin
        case (walk_state)
            LEFT: next_walk_state = (bump_left && fall_state == GROUNDED) ? RIGHT : LEFT;
            RIGHT: next_walk_state = (bump_right && fall_state == GROUNDED) ? RIGHT : LEFT;
            default: next_walk_state = LEFT;
        endcase
    end

    // Falling FSM
    always @(*) begin
        case (fall_state)
            GROUNDED: next_fall_state = (!ground) ? FALLING : GROUNDED;
            FALLING: next_fall_state = (ground) ? GROUNDED : FALLING;
            default: next_fall_state = GROUNDED;
        endcase
    end

    // State registers
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walk_state <= LEFT;
            fall_state <= GROUNDED;
        end else begin
            walk_state <= next_walk_state;
            fall_state <= next_fall_state;
        end
    end

    // Output logic
    assign walk_left = (fall_state == GROUNDED) && (walk_state == LEFT);
    assign walk_right = (fall_state == GROUNDED) && (walk_state == RIGHT);
    assign aaah = (fall_state == FALLING);

endmodule