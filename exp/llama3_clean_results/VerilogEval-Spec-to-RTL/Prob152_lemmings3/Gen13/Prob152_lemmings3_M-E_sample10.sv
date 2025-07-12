module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Walking Module
reg walk_dir;
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b0; // Initial direction: left
    end else if (bump_left) begin
        walk_dir <= 1'b1; // Switch to right
    end else if (bump_right) begin
        walk_dir <= 1'b0; // Switch to left
    end
end

// Falling Module
reg is_falling;
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        is_falling <= 1'b0;
    end else if (!ground) begin
        is_falling <= 1'b1;
    end else if (ground && !is_falling) begin
        is_falling <= 1'b0;
    end
end

// Digging Module
reg is_digging;
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        is_digging <= 1'b0;
    end else if (dig && ground && !is_falling) begin
        is_digging <= 1'b1;
    end else if (!ground || is_falling) begin
        is_digging <= 1'b0;
    end
end

// Output logic
assign walk_left = (walk_dir == 1'b0 && !is_falling && !is_digging) ? 1'b1 : 1'b0;
assign walk_right = (walk_dir == 1'b1 && !is_falling && !is_digging) ? 1'b1 : 1'b0;
assign aaah = is_falling ? 1'b1 : 1'b0;
assign digging = is_digging ? 1'b1 : 1'b0;

endmodule