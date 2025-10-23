module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    reg state;  // 0: WALK_LEFT, 1: WALK_RIGHT

    // Simplified state transition logic
    wire next_state = (state == 1'b0) ? 
                     (bump_left ? 1'b1 : 1'b0) : 
                     (bump_right ? 1'b0 : 1'b1);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign walk_left = ~state;
    assign walk_right = state;

endmodule