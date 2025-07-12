module TopModule (
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    output          walk_left,
    output          walk_right
);

enum logic [0:0] {WALK_LEFT, WALK_RIGHT} state, next_state;

always_comb begin
    case (state)
        WALK_LEFT: begin
            if (bump_left) next_state = WALK_RIGHT;
            else next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (bump_right) next_state = WALK_LEFT;
            else next_state = WALK_RIGHT;
        end
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        if (bump_left && bump_right) begin
            state <= (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
        end else begin
            state <= next_state;
        end
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
    endcase
end

endmodule