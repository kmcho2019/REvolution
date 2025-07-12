module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

typedef enum logic [0:0] {LEFT, RIGHT} state_t;

state_t state, next_state;

always_comb begin
    case(state)
        LEFT: if (bump_left) next_state = RIGHT;
              else next_state = LEFT;
        RIGHT: if (bump_right) next_state = LEFT;
                else next_state = RIGHT;
        default: next_state = LEFT;
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= LEFT;
    else state <= next_state;
end

always_comb begin
    case(state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

endmodule