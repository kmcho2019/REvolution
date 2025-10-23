module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg direction;  // 0=left, 1=right

    // Toggle direction on any bump
    wire toggle = bump_left | bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset)
            direction <= 1'b0;  // Reset to walk left
        else if (toggle)
            direction <= ~direction;
    end

    // Output logic
    assign walk_left = ~direction;
    assign walk_right = direction;

endmodule