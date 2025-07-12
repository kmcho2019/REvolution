module TopModule (
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

reg walk_direction; // 0: left, 1: right
reg falling; // 1: falling, 0: not falling
reg digging_reg; // 1: digging, 0: not digging

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_direction <= 0; // left
        falling <= 0; // not falling
        digging_reg <= 0; // not digging
    end else begin
        if (!ground) begin
            falling <= 1; // falling
            digging_reg <= 0; // not digging
        end else if (dig &&!falling &&!digging_reg) begin
            digging_reg <= 1; // digging
        end else if (ground &&!digging_reg) begin
            if (bump_left) begin
                walk_direction <= 1; // right
            end else if (bump_right) begin
                walk_direction <= 0; // left
            end
            falling <= 0; // not falling
        end else if (ground &&!digging_reg && falling) begin
            falling <= 0; // not falling
        end else if (!ground && digging_reg) begin
            digging_reg <= 0; // not digging
        end
    end
end

assign walk_left = (!falling &&!digging_reg && walk_direction == 0)? 1'b1 : 1'b0;
assign walk_right = (!falling &&!digging_reg && walk_direction == 1)? 1'b1 : 1'b0;
assign aaah = falling? 1'b1 : 1'b0;
assign digging = digging_reg? 1'b1 : 1'b0;

endmodule