module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg direction;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 'b0; // walk left by default
    end else if (bump_left || bump_right) begin
        direction <= ~direction; // toggle direction on bump
    end
end

assign walk_left = ~direction;
assign walk_right = direction;

endmodule