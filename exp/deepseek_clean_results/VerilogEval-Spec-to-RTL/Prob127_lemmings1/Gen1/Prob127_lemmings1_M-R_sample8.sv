module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State register (0 = left, 1 = right)
    reg state;

    // Combined state transition and register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to walk left
        end else begin
            case (state)
                1'b0: state <= bump_left ? 1'b1 : 1'b0;  // Left to right if bumped
                1'b1: state <= bump_right ? 1'b0 : 1'b1; // Right to left if bumped
            endcase
        end
    end

    // Output assignments (direct from state)
    assign walk_left = ~state;
    assign walk_right = state;

endmodule