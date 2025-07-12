module TopModule(
    input        clk,
    input        areset,
    input        bump_left,
    input        bump_right,
    output       walk_left,
    output       walk_right
);

enum logic [0:0] {WALK_LEFT, WALK_RIGHT} state, next_state;

always_comb begin
    case(state)
        WALK_LEFT: begin
            if (bump_left) next_state = WALK_RIGHT;
            else next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (bump_right) next_state = WALK_LEFT;
            else next_state = WALK_RIGHT;
        end
    endcase

    if (bump_left && bump_right) begin
        case(state)
            WALK_LEFT: next_state = WALK_RIGHT;
            WALK_RIGHT: next_state = WALK_LEFT;
        endcase
    end
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= WALK_LEFT;
    else state <= next_state;
end

assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);

endmodule