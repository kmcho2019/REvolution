module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = WALK_LEFT, 1 = WALK_RIGHT

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else if (state)  // WALK_RIGHT
            state <= ~bump_right;
        else             // WALK_LEFT
            state <= bump_left;
    end

    assign walk_left = ~state;
    assign walk_right = state;

endmodule