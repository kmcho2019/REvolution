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

// Initialize state to walking left
initial begin
    walking_left = 1'b1;
    falling = 1'b0;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_left <= 1'b1;
        falling <= 1'b0;
    end else begin
        if (~ground) begin
            falling <= 1'b1;
        end else if (falling && ground) begin
            falling <= 1'b0;
        end
        
        if (!falling) begin
            if (bump_left && !bump_right) begin
                walking_left <= 1'b0;
            end else if (bump_right && !bump_left) begin
                walking_left <= 1'b1;
            end else if (bump_left && bump_right) begin
                walking_left <= ~walking_left;
            end
        end
    end
end

// Output logic
assign walk_left = walking_left && !falling;
assign walk_right = !walking_left && !falling;
assign aaah = falling;

endmodule