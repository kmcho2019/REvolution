module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg walking_left;
reg falling;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_left <= 1'b1;
        falling <= 1'b0;
    end else begin
        if (!ground && !falling) begin
            falling <= 1'b1;
        end else if (ground && falling) begin
            falling <= 1'b0;
        end else if (!falling) begin
            if (bump_left) begin
                walking_left <= 1'b0;
            end else if (bump_right) begin
                walking_left <= 1'b1;
            end
        end
    end
end

always @(*) begin
    walk_left = !falling && walking_left;
    walk_right = !falling && !walking_left;
    aaah = falling;
end

endmodule