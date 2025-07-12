module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

typedef enum {LEFT, RIGHT} state_t;
state_t state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
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

always @(*) begin
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
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    endcase
end

endmodule