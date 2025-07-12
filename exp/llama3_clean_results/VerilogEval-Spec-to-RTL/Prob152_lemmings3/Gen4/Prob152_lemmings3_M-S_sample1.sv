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

reg [1:0] state; // 2'b00 - Walking, 2'b01 - Digging, 2'b10 - Falling
reg walk_left_reg; // 1 - Walking left, 0 - Walking right
reg aaah_reg, digging_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking
        walk_left_reg <= 1'b1; // Reset to walking left
        aaah_reg <= 1'b0;
        digging_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Walking
                if (bump_left) begin
                    walk_left_reg <= 1'b0; // Switch to walking right
                end else if (bump_right) begin
                    walk_left_reg <= 1'b1; // Switch to walking left
                end else if (!ground) begin
                    state <= 2'b10; // Start falling
                end else if (dig) begin
                    state <= 2'b01; // Start digging
                end
            end
            2'b01: begin // Digging
                if (!ground) begin
                    state <= 2'b10; // Start falling
                end
            end
            2'b10: begin // Falling
                if (ground) begin
                    state <= 2'b00; // Resume walking
                    aaah_reg <= 1'b0;
                end else begin
                    aaah_reg <= 1'b1;
                end
            end
        endcase
    end
end

assign walk_left = walk_left_reg;
assign walk_right = !walk_left_reg;
assign aaah = aaah_reg;
assign digging = state == 2'b01;

endmodule