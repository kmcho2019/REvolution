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

reg [1:0] state, next_state;
reg direction, next_direction;

// Sequential logic for state and direction registers
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `STATE_WALK;
        direction <= `DIR_LEFT;
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

// Combinational logic for next state and direction
assign next_state = (state == `STATE_WALK &&!ground)? `STATE_FALL :
                    (state == `STATE_WALK && dig)? `STATE_DIG :
                    (state == `STATE_FALL && ground)? `STATE_WALK :
                    (state == `STATE_DIG &&!ground)? `STATE_FALL :
                    state;

assign next_direction = (state == `STATE_WALK && bump_left && direction == `DIR_LEFT)? `DIR_RIGHT :
                        (state == `STATE_WALK && bump_right && direction == `DIR_RIGHT)? `DIR_LEFT :
                        direction;

// Output logic
assign walk_left = (state == `STATE_WALK && direction == `DIR_LEFT);
assign walk_right = (state == `STATE_WALK && direction == `DIR_RIGHT);
assign aaah = (state == `STATE_FALL);
assign digging = (state == `STATE_DIG);

endmodule