module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state; // 0: walking, 1: falling, 2: digging
reg walk_dir; // 0: walking left, 1: walking right

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 0; // walking
        walk_dir <= 0; // walking left
    end else if (clk) begin
        case (state)
            0: begin // walking
                if (!ground) begin
                    state <= 1; // falling
                end else if (dig) begin
                    state <= 2; // digging
                end else if (bump_left &&!bump_right) begin
                    walk_dir <= 1; // walking right
                end else if (bump_right &&!bump_left) begin
                    walk_dir <= 0; // walking left
                end else if (bump_left && bump_right) begin
                    walk_dir <= ~walk_dir; // switch direction
                end
            end
            1: begin // falling
                if (ground) begin
                    state <= 0; // walking
                end
            end
            2: begin // digging
                if (!ground) begin
                    state <= 1; // falling
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // walking
            walk_left = ~walk_dir;
            walk_right = walk_dir;
            aaah = 0;
            digging = 0;
        end
        1: begin // falling
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        2: begin // digging
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
    endcase
end

endmodule