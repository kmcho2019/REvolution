module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0 = walk_left, 1 = walk_right

    // Registers to hold previous bump signals for edge detection
    reg prev_bump_left, prev_bump_right;

    wire bump_event;
    assign bump_event = ((bump_left & ~prev_bump_left) | (bump_right & ~prev_bump_right));

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // walk_left
            prev_bump_left  <= 1'b0;
            prev_bump_right <= 1'b0;
        end else begin
            prev_bump_left  <= bump_left;
            prev_bump_right <= bump_right;

            if (bump_event)
                state <= ~state;
        end
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule