module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg direction;

// Toggle flip-flop
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0;
    end else if (bump_left || bump_right) begin
        direction <= ~direction;
    end
end

// Generate outputs
assign walk_left = ~direction;
assign walk_right = direction;

endmodule