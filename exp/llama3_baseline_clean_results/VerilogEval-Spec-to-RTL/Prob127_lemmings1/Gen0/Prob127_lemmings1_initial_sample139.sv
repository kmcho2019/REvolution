module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] current_state;  // 0: walking left, 1: walking right
reg [0:0] next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 0;  // reset to walking left
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        0: begin  // walking left
            if (bump_left) begin
                next_state = 1;  // switch to walking right
            end else begin
                next_state = 0;  // stay walking left
            end
        end
        1: begin  // walking right
            if (bump_right) begin
                next_state = 0;  // switch to walking left
            end else begin
                next_state = 1;  // stay walking right
            end
        end
        default: begin
            next_state = 0;  // default to walking left
        end
    endcase

    if (bump_left && bump_right) begin
        next_state = ~current_state;  // switch directions if bumped on both sides
    end
end

always_comb begin
    case (current_state)
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