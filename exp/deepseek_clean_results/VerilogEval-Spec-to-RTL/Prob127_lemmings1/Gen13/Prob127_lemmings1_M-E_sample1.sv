module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // Combinational next state logic based on current outputs
    wire next_walk_left = (walk_right & bump_right) | (walk_left & ~bump_left);
    wire next_walk_right = (walk_left & bump_left) | (walk_right & ~bump_right);

    // Registered outputs with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end else begin
            walk_left <= next_walk_left;
            walk_right <= next_walk_right;
        end
    end

endmodule