module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left <= 1'b1; // Initialize to walk left
        walk_right <= 1'b0;
    end else begin
        if (bump_left && !bump_right) begin
            walk_left <= 1'b0; // Switch to walk right
            walk_right <= 1'b1;
        end else if (!bump_left && bump_right) begin
            walk_left <= 1'b1; // Switch to walk left
            walk_right <= 1'b0;
        end else if (bump_left && bump_right) begin
            walk_left <= ~walk_left; // Switch direction
            walk_right <= ~walk_right;
        end
    end
end

endmodule