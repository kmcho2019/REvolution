module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State register (0 = left, 1 = right)
    reg direction;

    // Toggle direction on any bump (XOR operation)
    wire toggle = bump_left || bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // Reset to walk left
        end else if (toggle) begin
            direction <= ~direction;  // Toggle direction on any bump
        end
    end

    // Output assignments
    assign walk_left = ~direction;
    assign walk_right = direction;

endmodule