module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// State definition
enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING
} state, next_state;

// Combinational logic for next state and output signals
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Sequential logic for state registers
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule