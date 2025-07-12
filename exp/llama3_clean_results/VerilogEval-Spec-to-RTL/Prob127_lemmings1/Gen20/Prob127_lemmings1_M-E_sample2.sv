module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

logic direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b1; // Initialize direction to left
    end else begin
        if (bump_left || bump_right) begin
            direction <= ~direction; // Toggle direction on bump
        end
    end
end

always_comb begin
    walk_left = direction;
    walk_right = ~direction;
end

endmodule