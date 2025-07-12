module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg toggle;  // 0=left, 1=right
    
    // Toggle direction on any bump
    wire next_toggle = toggle ^ (bump_left | bump_right);
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            toggle <= 1'b0;  // Start walking left
        else
            toggle <= next_toggle;
    end
    
    // Output assignments
    assign walk_left = ~toggle;
    assign walk_right = toggle;

endmodule