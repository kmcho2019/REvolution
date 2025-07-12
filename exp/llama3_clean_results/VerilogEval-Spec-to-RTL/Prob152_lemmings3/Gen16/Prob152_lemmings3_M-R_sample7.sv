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

reg state; // 0: walking/falling, 1: digging
reg walk_direction; // 0: left, 1: right
reg prev_ground;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking
        walk_direction <= 0; // left
        prev_ground <= 1;
    end else begin
        if (!ground && prev_ground) begin
            state <= 0; // falling
        end else if (ground &&!prev_ground) begin
            state <= 0; // walking
        end else if (dig && ground) begin
            state <= 1; // digging
        end else if (bump_left && state!= 1) begin
            walk_direction <= 1; // right
        end else if (bump_right && state!= 1) begin
            walk_direction <= 0; // left
        end
        prev_ground <= ground;
    end
end

assign walk_left = (state == 0 &&!walk_direction && ground)? 1'b1 : 1'b0;
assign walk_right = (state == 0 && walk_direction && ground)? 1'b1 : 1'b0;
assign aaah = (state == 0 &&!ground)? 1'b1 : 1'b0;
assign digging = (state == 1)? 1'b1 : 1'b0;

endmodule