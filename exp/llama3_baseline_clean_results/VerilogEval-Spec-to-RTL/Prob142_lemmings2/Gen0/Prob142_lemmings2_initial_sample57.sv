module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // but we will only use 2 values: 0 for walking, 1 for falling
reg direction; // 0 for left, 1 for right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking
        direction <= 0; // left
    end else begin
        if (~ground) begin // falling
            state <= 1;
        end else if (state == 1) begin // was falling, now walking again
            state <= 0;
        end else begin // walking
            if (bump_left) begin
                direction <= 1; // turn right
            end else if (bump_right) begin
                direction <= 0; // turn left
            end
        end
    end
end

assign walk_left = (state == 0) && (direction == 0);
assign walk_right = (state == 0) && (direction == 1);
assign aaah = (state == 1);

endmodule