module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    // Next state combinational logic as assign
    wire next_state = (bump_left | bump_right) ? 
                      ((bump_left & bump_right) ? ~state : (bump_left ? 1'b1 : 1'b0))
                      : state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    assign walk_left  = (state == 1'b0);
    assign walk_right = (state == 1'b1);

endmodule