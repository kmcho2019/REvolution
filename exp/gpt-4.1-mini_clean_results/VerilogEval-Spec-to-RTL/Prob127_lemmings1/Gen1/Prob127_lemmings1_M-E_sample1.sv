module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0 = walk left, 1 = walk right
    wire bump_any = bump_left | bump_right;

    // Asynchronous positive edge reset, synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk left after reset
        else if (bump_any)
            state <= ~state; // toggle state on bump
        else
            state <= state; // hold state otherwise
    end

    // Output assignments (Moore machine)
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule