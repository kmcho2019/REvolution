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

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `STATE_WALK;
        direction <= `DIR_LEFT;
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

always_comb begin
    next_state = state;
    next_direction = direction;
    
    case (state)
        `STATE_WALK: begin
            if (!ground) begin
                next_state = `STATE_FALL;
            end else if (dig && ground) begin
                next_state = `STATE_DIG;
            end else if (bump_left && (direction == `DIR_LEFT)) begin
                next_direction = `DIR_RIGHT;
            end else if (bump_right && (direction == `DIR_RIGHT)) begin
                next_direction = `DIR_LEFT;
            end
        end
        `STATE_FALL: begin
            if (ground) begin
                next_state = `STATE_WALK;
            end
        end
        `STATE_DIG: begin
            if (!ground) begin
                next_state = `STATE_FALL;
            end
        end
    endcase
end

assign walk_left = (state == `STATE_WALK && direction == `DIR_LEFT);
assign walk_right = (state == `STATE_WALK && direction == `DIR_RIGHT);
assign aaah = (state == `STATE_FALL);
assign digging = (state == `STATE_DIG);

endmodule