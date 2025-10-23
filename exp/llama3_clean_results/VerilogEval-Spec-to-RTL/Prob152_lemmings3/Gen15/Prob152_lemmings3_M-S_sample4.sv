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

reg state; // 0: walking, 1: falling
reg walk_direction; // 0: left, 1: right
reg is_digging;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking
        walk_direction <= 0; // left
        is_digging <= 0;
    end else begin
        if (!ground) begin
            state <= 1; // falling
            is_digging <= 0;
        end else if (dig && state == 0 &&!is_digging) begin
            is_digging <= 1;
        end else if (state == 1 && ground) begin
            state <= 0; // walking
        end else if (bump_left && state!= 1) begin
            walk_direction <= 1; // right
        end else if (bump_right && state!= 1) begin
            walk_direction <= 0; // left
        end
    end
end

assign walk_left = (state == 0 &&!walk_direction &&!is_digging)? 1'b1 : 1'b0;
assign walk_right = (state == 0 && walk_direction &&!is_digging)? 1'b1 : 1'b0;
assign aaah = (state == 1)? 1'b1 : 1'b0;
assign digging = is_digging;

endmodule