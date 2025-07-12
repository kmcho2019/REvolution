module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;  // LEFT or RIGHT
    wire should_toggle;

    // Only toggle when exactly one bump signal is active
    assign should_toggle = bump_left ^ bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else if (should_toggle)
            state <= ~state;
    end

    assign walk_left = ~state;
    assign walk_right = state;

endmodule