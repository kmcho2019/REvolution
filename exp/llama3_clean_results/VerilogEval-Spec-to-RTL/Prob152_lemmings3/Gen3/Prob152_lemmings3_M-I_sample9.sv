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

reg [1:0] state; // 2'b00 - Walking left, 2'b01 - Walking right, 2'b10 - Digging, 2'b11 - Falling
reg prev_walk_left, prev_walk_right;
reg walk_left_reg, walk_right_reg, aaah_reg, digging_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking left
        prev_walk_left <= 1'b1;
        prev_walk_right <= 1'b0;
        walk_left_reg <= 1'b1;
        walk_right_reg <= 1'b0;
        aaah_reg <= 1'b0;
        digging_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Walking left
                if (!ground) begin
                    state <= 2'b11; // Start falling
                    prev_walk_left <= 1'b1;
                    prev_walk_right <= 1'b0;
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b1;
                    digging_reg <= 1'b0;
                end else if (bump_left) begin
                    state <= 2'b01; // Switch to walking right
                    prev_walk_left <= 1'b0;
                    prev_walk_right <= 1'b1;
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b1;
                end else if (dig) begin
                    state <= 2'b10; // Start digging
                    prev_walk_left <= 1'b1;
                    prev_walk_right <= 1'b0;
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b0;
                    digging_reg <= 1'b1;
                end
            end
            2'b01: begin // Walking right
                if (!ground) begin
                    state <= 2'b11; // Start falling
                    prev_walk_left <= 1'b0;
                    prev_walk_right <= 1'b1;
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b1;
                    digging_reg <= 1'b0;
                end else if (bump_right) begin
                    state <= 2'b00; // Switch to walking left
                    prev_walk_left <= 1'b1;
                    prev_walk_right <= 1'b0;
                    walk_left_reg <= 1'b1;
                    walk_right_reg <= 1'b0;
                end else if (dig) begin
                    state <= 2'b10; // Start digging
                    prev_walk_left <= 1'b0;
                    prev_walk_right <= 1'b1;
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b0;
                    digging_reg <= 1'b1;
                end
            end
            2'b10: begin // Digging
                if (!ground) begin
                    state <= 2'b11; // Start falling
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b1;
                    digging_reg <= 1'b0;
                end
            end
            2'b11: begin // Falling
                if (ground) begin
                    if (prev_walk_left) begin
                        state <= 2'b00; // Resume walking left
                        walk_left_reg <= 1'b1;
                        walk_right_reg <= 1'b0;
                    end else begin
                        state <= 2'b01; // Resume walking right
                        walk_left_reg <= 1'b0;
                        walk_right_reg <= 1'b1;
                    end
                    aaah_reg <= 1'b0;
                    digging_reg <= 1'b0;
                end
            end
        endcase
    end
end

assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;
assign aaah = aaah_reg;
assign digging = digging_reg;

endmodule