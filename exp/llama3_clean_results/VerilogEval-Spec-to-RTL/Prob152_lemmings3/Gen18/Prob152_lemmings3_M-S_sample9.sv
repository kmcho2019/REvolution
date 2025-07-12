`define STATE_WALK 1'b0
`define STATE_FALL 1'b1

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

reg state; // 0: walking/digging, 1: falling
reg walk_direction; // 0: left, 1: right

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `STATE_WALK;
        walk_direction <= 1'b0; // left
    end else begin
        if (!ground && (state == `STATE_WALK)) begin
            state <= `STATE_FALL;
        end else if (ground && (state == `STATE_FALL)) begin
            state <= `STATE_WALK;
        end
        if (bump_left && (state == `STATE_WALK)) begin
            walk_direction <= 1'b1; // right
        end else if (bump_right && (state == `STATE_WALK)) begin
            walk_direction <= 1'b0; // left
        end
    end
end

always_comb begin
    walk_left = (state == `STATE_WALK && !walk_direction);
    walk_right = (state == `STATE_WALK && walk_direction);
    aaah = (state == `STATE_FALL);
    digging = (state == `STATE_WALK && dig && ground);
end

endmodule