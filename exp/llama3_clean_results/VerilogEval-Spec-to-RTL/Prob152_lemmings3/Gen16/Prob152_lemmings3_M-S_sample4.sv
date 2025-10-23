`define STATE_WALK 2'b00
`define STATE_FALL 2'b01
`define STATE_DIG 2'b10

`define DIR_LEFT 1'b0
`define DIR_RIGHT 1'b1

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

reg [1:0] state; // 0: walking, 1: falling, 2: digging
reg walk_direction; // 0: left, 1: right
reg prev_ground;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `STATE_WALK; // walking
        walk_direction <= `DIR_LEFT; // left
    end else begin
        case (state)
            `STATE_WALK: begin
                if (!ground) state <= `STATE_FALL; // falling
                else if (dig) state <= `STATE_DIG; // digging
                else if (bump_left || bump_right) walk_direction <= ~walk_direction; // switch direction
            end
            `STATE_FALL: begin
                if (ground) state <= `STATE_WALK; // walking
            end
            `STATE_DIG: begin
                if (!ground) state <= `STATE_FALL; // falling
            end
        endcase
    end
end

always_comb begin
    walk_left = (state == `STATE_WALK && walk_direction == `DIR_LEFT);
    walk_right = (state == `STATE_WALK && walk_direction == `DIR_RIGHT);
    aaah = (state == `STATE_FALL);
    digging = (state == `STATE_DIG);
end

endmodule