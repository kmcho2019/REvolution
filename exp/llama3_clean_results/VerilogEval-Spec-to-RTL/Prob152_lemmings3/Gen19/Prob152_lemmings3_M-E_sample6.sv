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

reg [1:0] top_state; // walking, falling, or digging
reg walk_direction; // left or right
reg prev_ground;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= `STATE_WALK; // walking
        walk_direction <= `DIR_LEFT; // left
        prev_ground <= 1;
    end else begin
        case (top_state)
            `STATE_WALK: begin // walking
                if (!ground) begin
                    top_state <= `STATE_FALL; // falling
                end else if (dig) begin
                    top_state <= `STATE_DIG; // digging
                end else if (bump_left) begin
                    walk_direction <= `DIR_RIGHT; // right
                end else if (bump_right) begin
                    walk_direction <= `DIR_LEFT; // left
                end
            end
            `STATE_FALL: begin // falling
                if (ground) begin
                    top_state <= `STATE_WALK; // walking
                end
            end
            `STATE_DIG: begin // digging
                if (!ground) begin
                    top_state <= `STATE_FALL; // falling
                end
            end
        endcase
        prev_ground <= ground;
    end
end

always_comb begin
    walk_left = (top_state == `STATE_WALK && walk_direction == `DIR_LEFT);
    walk_right = (top_state == `STATE_WALK && walk_direction == `DIR_RIGHT);
    aaah = (top_state == `STATE_FALL);
    digging = (top_state == `STATE_DIG);
end

endmodule