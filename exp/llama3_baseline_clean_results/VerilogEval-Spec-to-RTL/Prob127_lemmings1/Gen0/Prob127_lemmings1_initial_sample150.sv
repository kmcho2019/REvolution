module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state, next_state;
parameter LEFT = 0, RIGHT = 1;

always @(*) begin
    case (state)
        LEFT: begin
            if (bump_left) next_state = RIGHT;
            else next_state = LEFT;
        end
        RIGHT: begin
            if (bump_right) next_state = LEFT;
            else next_state = RIGHT;
        end
        default: next_state = LEFT;
    endcase

    if (bump_left && bump_right) begin
        case (state)
            LEFT: next_state = RIGHT;
            RIGHT: next_state = LEFT;
            default: next_state = LEFT;
        endcase
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) state <= LEFT;
    else state <= next_state;
end

always @(*) begin
    case (state)
        LEFT: begin
            walk_left = 1;
            walk_right = 0;
        end
        RIGHT: begin
            walk_left = 0;
            walk_right = 1;
        end
        default: begin
            walk_left = 1;
            walk_right = 0;
        end
    endcase
end

endmodule