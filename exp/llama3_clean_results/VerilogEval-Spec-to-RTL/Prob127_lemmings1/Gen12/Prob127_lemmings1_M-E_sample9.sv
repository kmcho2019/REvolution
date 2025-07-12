module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg current_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_direction <= 1'b0; // Initial direction: left
    end else begin
        if (bump_left && bump_right) begin
            current_direction <= ~current_direction; // Switch direction
        end else if (bump_left) begin
            current_direction <= 1'b1; // Move right
        end else if (bump_right) begin
            current_direction <= 1'b0; // Move left
        end
    end
end

always_comb begin
    walk_left = ~current_direction;
    walk_right = current_direction;
end

endmodule