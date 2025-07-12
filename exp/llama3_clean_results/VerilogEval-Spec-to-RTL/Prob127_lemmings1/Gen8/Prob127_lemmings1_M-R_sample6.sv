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
        direction <= 1'b0; // Initialize to walking left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        if ((direction == 1'b0 && bump_left) || (direction == 1'b1 && bump_right)) begin
            direction <= ~direction; // Switch direction
        end
        walk_left <= ~direction;
        walk_right <= direction;
    end
end

endmodule