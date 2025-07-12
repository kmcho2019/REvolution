module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0: walk_left, 1: walk_right

    // Optimized state transition using XOR
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to walk_left
        end else begin
            state <= state ^ (state ? bump_right : bump_left);
        end
    end

    // Direct output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule