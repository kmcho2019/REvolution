module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state; // 0: walking left, 1: walking right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
    end else begin
        case (state)
            0: begin // walking left
                if (bump_left) begin
                    state <= 1; // switch to walking right
                end else begin
                    state <= 0; // stay walking left
                end
            end
            1: begin // walking right
                if (bump_right) begin
                    state <= 0; // switch to walking left
                end else begin
                    state <= 1; // stay walking right
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin
            walk_left = 1;
            walk_right = 0;
        end
        1: begin
            walk_left = 0;
            walk_right = 1;
        end
    endcase
end

endmodule