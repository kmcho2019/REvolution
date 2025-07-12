module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state, next_state;

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to walk_left
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = (bump_left & bump_right) ? ~state :
                     bump_left ? 1'b1 :
                     bump_right ? 1'b0 :
                     state;
    end

    // Moore output logic: outputs depend only on current state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule