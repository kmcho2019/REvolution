module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg dir;  // Direction register: 0=left, 1=right

    // State transition (toggle direction when bumped)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            dir <= 1'b0;  // Reset to walk left
        end else if (bump_left || bump_right) begin
            dir <= ~dir;  // Toggle direction
        end
    end

    // Output logic
    assign walk_left = ~dir;
    assign walk_right = dir;

endmodule