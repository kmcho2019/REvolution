module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0;
    end else if (bump_left && bump_right) begin
        direction <= ~direction;
    end else if (bump_left) begin
        direction <= 1;
    end else if (bump_right) begin
        direction <= 0;
    end
end

always_comb begin
    if (direction) begin
        walk_left = 0;
        walk_right = 1;
    end else begin
        walk_left = 1;
        walk_right = 0;
    end
end

endmodule