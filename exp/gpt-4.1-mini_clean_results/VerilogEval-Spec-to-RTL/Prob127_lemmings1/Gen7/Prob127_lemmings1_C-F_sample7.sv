module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk_left
        else begin
            if (bump_left && bump_right)
                state <= ~state;       // toggle direction
            else if (bump_left)
                state <= 1'b1;         // walk_right
            else if (bump_right)
                state <= 1'b0;         // walk_left
            else
                state <= state;        // hold current state
        end
    end

    // Moore outputs derived directly from state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule