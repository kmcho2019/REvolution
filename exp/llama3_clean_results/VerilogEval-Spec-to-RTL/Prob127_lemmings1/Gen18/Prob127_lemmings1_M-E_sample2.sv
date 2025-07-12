module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg direction;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // Initialize direction to 0 (left)
    end else begin
        if (bump_left || bump_right) begin
            direction <= ~direction; // Toggle direction on bump
        end
    end
end

// Define combinational logic
always_comb begin
    if (direction == 1'b0) begin
        walk_left = 1'b1;
        walk_right = 1'b0;
    end else begin
        walk_left = 1'b0;
        walk_right = 1'b1;
    end
end

endmodule