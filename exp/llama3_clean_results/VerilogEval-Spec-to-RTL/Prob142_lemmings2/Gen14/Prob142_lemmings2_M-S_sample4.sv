module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg direction; // 1 for walking right, 0 for walking left
reg falling;

// Combinational logic to determine the next state
always @(*) begin
    walk_left = direction ? 1'b0 : 1'b1;
    walk_right = direction ? 1'b1 : 1'b0;
    aaah = falling ? 1'b1 : 1'b0;
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // reset to walking left
        falling <= 1'b0;
    end else begin
        if (~ground) begin
            falling <= 1'b1;
        end else if (ground && falling) begin
            falling <= 1'b0;
        end else if (bump_left && !falling) begin
            direction <= 1'b1; // switch to walking right
        end else if (bump_right && !falling) begin
            direction <= 1'b0; // switch to walking left
        end
    end
end

endmodule