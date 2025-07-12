module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

logic direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // Initialize to walk left
    end else if (bump_left || bump_right) begin
        direction <= ~direction; // Toggle direction
    end
end

always_comb begin
    if (direction) begin
        walk_left = 1'b0;
        walk_right = 1'b1;
    end else begin
        walk_left = 1'b1;
        walk_right = 1'b0;
    end
end

endmodule