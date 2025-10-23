module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

typedef enum logic {WALK_LEFT, WALK_RIGHT} state_t;
state_t current_state, next_state;

always_comb begin
    case (current_state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        default: next_state = WALK_LEFT;
    endcase

    // Simplified logic to handle bump_left && bump_right condition
    if (bump_left && bump_right) begin
        next_state = (current_state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
    end
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

assign walk_left = (current_state == WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (current_state == WALK_RIGHT) ? 1'b1 : 1'b0;

endmodule