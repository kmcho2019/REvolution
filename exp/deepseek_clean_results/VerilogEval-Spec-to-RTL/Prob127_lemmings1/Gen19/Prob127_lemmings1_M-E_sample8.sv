module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg toggle;
    wire next_toggle;

    // Next state logic: toggle when either bump occurs
    assign next_toggle = toggle ^ (bump_left | bump_right);

    // State register with async reset (starts walking left)
    always @(posedge clk or posedge areset) begin
        if (areset)
            toggle <= 1'b0;
        else
            toggle <= next_toggle;
    end

    // Output logic: 
    // - toggle=0 means walk left
    // - toggle=1 means walk right
    // Bump_left has priority if both bumps occur simultaneously
    assign walk_left = ~(toggle ^ bump_left);
    assign walk_right = toggle ^ bump_left;

endmodule