module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg current_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 0; // reset to walking left
    end else begin
        case(current_state)
            0: begin // walking left
                if (bump_left) begin
                    current_state <= 1; // transition to walking right
                end else if (bump_right) begin
                    current_state <= 0; // stay walking left
                end else begin
                    current_state <= 0; // stay walking left
                end
            end
            1: begin // walking right
                if (bump_right) begin
                    current_state <= 0; // transition to walking left
                end else if (bump_left) begin
                    current_state <= 1; // stay walking right
                end else begin
                    current_state <= 1; // stay walking right
                end
            end
            default: begin
                current_state <= 0; // default to walking left
            end
        endcase
    end
end

assign walk_left = ~current_state;
assign walk_right = current_state;

endmodule