module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

typedef enum logic [0:0] {
    LEFT,
    RIGHT
} state_t;

state_t state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        LEFT: begin
            if (bump_left) begin
                next_state = RIGHT;
            end else if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            if (bump_right) begin
                next_state = LEFT;
            end else if (bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = RIGHT;
            end
        end
        default: next_state = LEFT;
    endcase
end

assign walk_left = (state == LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == RIGHT) ? 1'b1 : 1'b0;

endmodule