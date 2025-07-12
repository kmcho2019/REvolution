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
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else if (bump_left && bump_right) begin
        walk_left <= ~walk_left;
        walk_right <= ~walk_right;
    end else if (bump_left) begin
        walk_left <= 1'b0;
        walk_right <= 1'b1;
    end else if (bump_right) begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end
end

endmodule