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

reg [3:0] state; // 4'b0001 - Walking left, 4'b0010 - Walking right, 4'b0100 - Digging left, 4'b1000 - Digging right, 4'b0000 - Falling
reg walk_left_reg, walk_right_reg, aaah_reg, digging_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 4'b0001; // Reset to walking left
        walk_left_reg <= 1'b1;
        walk_right_reg <= 1'b0;
        aaah_reg <= 1'b0;
        digging_reg <= 1'b0;
    end else begin
        case (state)
            4'b0001: begin // Walking left
                if (!ground) begin
                    state <= 4'b0000; // Start falling
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b1;
                    digging_reg <= 1'b0;
                end else if (bump_left) begin
                    state <= 4'b0010; // Switch to walking right
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b1;
                end else if (dig) begin
                    state <= 4'b0100; // Start digging left
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b0;
                    digging_reg <= 1'b1;
                end
            end
            4'b0010: begin // Walking right
                if (!ground) begin
                    state <= 4'b0000; // Start falling
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b1;
                    digging_reg <= 1'b0;
                end else if (bump_right) begin
                    state <= 4'b0001; // Switch to walking left
                    walk_left_reg <= 1'b1;
                    walk_right_reg <= 1'b0;
                end else if (dig) begin
                    state <= 4'b1000; // Start digging right
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b0;
                    digging_reg <= 1'b1;
                end
            end
            4'b0100: begin // Digging left
                if (!ground) begin
                    state <= 4'b0000; // Start falling
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b1;
                    digging_reg <= 1'b0;
                end
            end
            4'b1000: begin // Digging right
                if (!ground) begin
                    state <= 4'b0000; // Start falling
                    walk_left_reg <= 1'b0;
                    walk_right_reg <= 1'b0;
                    aaah_reg <= 1'b1;
                    digging_reg <= 1'b0;
                end
            end
            4'b0000: begin // Falling
                if (ground) begin
                    if (state == 4'b0000) begin
                        if (state == 4'b0100 || state == 4'b1000) begin
                            state <= 4'b0001;
                        end else if (state == 4'b0010 || state == 4'b1000) begin
                            state <= 4'b0010;
                        end else begin
                            state <= 4'b0001;
                        end
                        walk_left_reg <= (state == 4'b0001 || state == 4'b0100)? 1'b1 : 1'b0;
                        walk_right_reg <= (state == 4'b0010 || state == 4'b1000)? 1'b1 : 1'b0;
                        aaah_reg <= 1'b0;
                        digging_reg <= 1'b0;
                    end
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