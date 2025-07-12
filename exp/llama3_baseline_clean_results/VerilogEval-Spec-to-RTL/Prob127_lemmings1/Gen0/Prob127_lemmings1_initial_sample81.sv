module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // 0: LEFT, 1: RIGHT
reg [0:0] next_state;

always @(*) begin
    case(state)
        0: begin // LEFT
            if (bump_left) next_state = 1; // switch to RIGHT
            else next_state = 0; // stay LEFT
        end
        1: begin // RIGHT
            if (bump_right) next_state = 0; // switch to LEFT
            else next_state = 1; // stay RIGHT
        end
        default: next_state = 0; // default to LEFT
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) state = 0; // reset to LEFT
    else state = next_state;
end

always @(*) begin
    case(state)
        0: begin // LEFT
            walk_left = 1;
            walk_right = 0;
        end
        1: begin // RIGHT
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