module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg walk_dir; // 0: walking left, 1: walking right
reg prev_walk_dir; // preserve previous walking direction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 0; // walking left
        prev_walk_dir <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
    end else begin
        if (ground == 1) begin
            // update previous walking direction
            prev_walk_dir <= walk_dir;
            
            // handle bumping conditions
            if (bump_left == 1 && bump_right == 0) begin
                walk_dir <= 1; // walk right
            end else if (bump_right == 1 && bump_left == 0) begin
                walk_dir <= 0; // walk left
            end else if (bump_left == 1 && bump_right == 1) begin
                walk_dir <= ~walk_dir; // switch direction
            end
            
            // update walk_left and walk_right outputs
            walk_left <= ~walk_dir;
            walk_right <= walk_dir;
            aaah <= 0;
        end else begin
            // preserve previous walking direction when falling
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
        end
        
        // resume walking in the same direction when ground reappears
        if (ground == 1 && prev_walk_dir != 0) begin
            walk_dir <= prev_walk_dir;
        end
    end
end

endmodule