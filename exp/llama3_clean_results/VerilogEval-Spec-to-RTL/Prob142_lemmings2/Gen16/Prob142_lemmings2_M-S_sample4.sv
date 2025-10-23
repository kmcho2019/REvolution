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

reg walk_dir; // 1: walk right, 0: walk left
reg falling;

// Combinational logic to determine the next state
always @(*) begin
    walk_dir = walk_dir;
    falling = falling;

    if (~ground) begin
        falling = 1'b1;
    end else if (ground && falling) begin
        falling = 1'b0;
    end else if ((bump_left && ~walk_dir) || (bump_right && walk_dir)) begin
        walk_dir = ~walk_dir;
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b0;
        falling <= 1'b0;
    end else begin
        walk_dir <= walk_dir;
        falling <= falling;
    end
end

// Output logic
assign walk_left = ~falling && ~walk_dir;
assign walk_right = ~falling && walk_dir;
assign aaah = falling;

endmodule