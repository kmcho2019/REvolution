module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

typedef enum logic [0:0] {
    WALK_LEFT,
    WALK_RIGHT
} state_type;

state_type state;
state_type next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // no change
            end else begin
                next_state = WALK_LEFT; // no change
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT; // no change
            end else begin
                next_state = WALK_RIGHT; // no change
            end
        end
        default: begin
            next_state = WALK_LEFT; // default state
        end
    endcase

    // if both bumps are high, switch direction
    if (bump_left && bump_right) begin
        case (state)
            WALK_LEFT: begin
                next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                next_state = WALK_LEFT;
            end
        endcase
    end
end

always_comb begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    endcase
end

endmodule