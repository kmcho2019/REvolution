module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // 0: walking left, 1: walking right
reg [0:0] next_state;

always @(*) begin
    case(state)
        0: begin // walking left
            if(bump_left) next_state = 1; // switch to walking right
            else next_state = 0; // stay walking left
        end
        1: begin // walking right
            if(bump_right) next_state = 0; // switch to walking left
            else next_state = 1; // stay walking right
        end
        default: next_state = 0;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) state <= 0; // reset to walking left
    else state <= next_state;
end

always @(*) begin
    case(state)
        0: begin
            walk_left = 1;
            walk_right = 0;
        end
        1: begin
            walk_left = 0;
            walk_right = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
        end
    endcase
end

endmodule