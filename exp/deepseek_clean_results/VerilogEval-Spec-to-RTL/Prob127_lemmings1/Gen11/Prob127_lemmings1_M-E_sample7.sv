module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg toggle;
    reg bump_left_prev, bump_right_prev;
    
    // Edge detection for bump signals
    wire bump_left_edge = bump_left & ~bump_left_prev;
    wire bump_right_edge = bump_right & ~bump_right_prev;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            toggle <= 0;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end else begin
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
            // Toggle direction on any bump edge
            if (bump_left_edge || bump_right_edge)
                toggle <= ~toggle;
        end
    end
    
    // Output assignments
    assign walk_left = ~toggle;
    assign walk_right = toggle;

endmodule