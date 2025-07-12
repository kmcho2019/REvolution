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

reg walk_dir; // 0: left, 1: right
reg falling;
reg current_digging;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 0; // left
        falling <= 0;
        current_digging <= 0;
    end else begin
        // Update walking direction based on bumps
        if (bump_left) begin
            walk_dir <= 1; // right
        end else if (bump_right) begin
            walk_dir <= 0; // left
        end
        
        // Manage falling state
        if (!ground && !falling) begin
            falling <= 1;
        end else if (ground && falling) begin
            falling <= 0;
        end
        
        // Manage digging state
        if (dig && ground && !current_digging) begin
            current_digging <= 1;
        end else if (!ground && current_digging) begin
            current_digging <= 0;
        end
    end
end

always_comb begin
    walk_left = (!falling && walk_dir == 0) ? 1'b1 : 1'b0;
    walk_right = (!falling && walk_dir == 1) ? 1'b1 : 1'b0;
    aaah = falling ? 1'b1 : 1'b0;
    digging = current_digging ? 1'b1 : 1'b0;
end

endmodule