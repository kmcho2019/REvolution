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

reg [1:0] state; // 0: falling, 1: walking, 2: digging
reg walk_direction; // 0: left, 1: right
reg prev_ground;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // walking
        walk_direction <= 0; // left
        prev_ground <= 1;
    end else if (~ground && (state == 1 || state == 2)) begin // falling
        state <= 0;
    end else if (ground && state == 0) begin // walking
        state <= 1;
    end else if (dig && state == 1 && ground) begin // digging
        state <= 2;
    end else if (bump_left && state == 1 && ground) begin
        walk_direction <= 1; // right
    end else if (bump_right && state == 1 && ground) begin
        walk_direction <= 0; // left
    end
end

always_comb begin
    walk_left = (state == 1 &&!walk_direction)? 1'b1 : 1'b0;
    walk_right = (state == 1 && walk_direction)? 1'b1 : 1'b0;
    aaah = (state == 0)? 1'b1 : 1'b0;
    digging = (state == 2)? 1'b1 : 1'b0;
end

endmodule