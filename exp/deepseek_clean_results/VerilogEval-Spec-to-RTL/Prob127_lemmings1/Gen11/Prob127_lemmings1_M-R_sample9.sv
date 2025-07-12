module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0: walk_left, 1: walk_right
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == 1'b0) ? 
                       (bump_left ? 1'b1 : 1'b0) : 
                       (bump_right ? 1'b0 : 1'b1);

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to walk_left
        end else begin
            state <= next_state;
        end
    end

    // Output logic remains the same
    assign walk_left = ~state;
    assign walk_right = state;

endmodule