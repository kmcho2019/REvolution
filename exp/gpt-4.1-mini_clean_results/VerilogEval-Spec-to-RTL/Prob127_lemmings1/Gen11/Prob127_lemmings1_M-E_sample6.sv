module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state bits
    reg walk_left_state, walk_right_state;

    wire bump_any = bump_left | bump_right;

    // Next state logic: flip direction on any bump
    wire walk_left_next  = (walk_left_state & ~bump_any) | (walk_right_state & bump_any);
    wire walk_right_next = (walk_right_state & ~bump_any) | (walk_left_state & bump_any);

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_state  <= 1'b1;
            walk_right_state <= 1'b0;
        end else begin
            walk_left_state  <= walk_left_next;
            walk_right_state <= walk_right_next;
        end
    end

    // Moore outputs directly from state bits
    assign walk_left  = walk_left_state;
    assign walk_right = walk_right_state;

endmodule