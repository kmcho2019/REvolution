module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // 0: LEFT, 1: RIGHT, 2: FALL
reg prev_state; // Previous state before falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to LEFT state
        prev_state <= 0;
    end else begin
        case (state)
            0: begin // LEFT
                if (ground == 0) begin
                    state <= 2; // Transition to FALL
                    prev_state <= 0;
                end else if (bump_left == 1) begin
                    state <= 1; // Transition to RIGHT
                end
            end
            1: begin // RIGHT
                if (ground == 0) begin
                    state <= 2; // Transition to FALL
                    prev_state <= 1;
                end else if (bump_right == 1) begin
                    state <= 0; // Transition to LEFT
                end
            end
            2: begin // FALL
                if (ground == 1) begin
                    state <= prev_state; // Transition back to previous state
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // LEFT
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        1: begin // RIGHT
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        2: begin // FALL
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
    endcase
end

endmodule