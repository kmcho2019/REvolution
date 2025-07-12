module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State bit: 0 = walk left, 1 = walk right
    reg state;

    wire bump_any = bump_left | bump_right;

    // State register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;          // Reset to walk left
        else if (bump_any)
            state <= ~state;        // Toggle direction on any bump
        else
            state <= state;         // Hold state if no bump
    end

    // Outputs combinationally driven by state (Moore outputs)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule