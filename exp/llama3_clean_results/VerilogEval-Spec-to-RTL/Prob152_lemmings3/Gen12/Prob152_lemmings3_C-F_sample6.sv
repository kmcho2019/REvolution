`define STATE_FALL 2'b00
`define STATE_WALK 2'b01
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

enum logic [1:0] {
    FALLING = `STATE_FALL,
    WALKING = `STATE_WALK,
    DIGGING = `STATE_DIG
} state, next_state;

enum logic [0:0] {
    LEFT = `DIR_LEFT,
    RIGHT = `DIR_RIGHT
} direction, next_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        direction <= LEFT;
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

always_comb begin
    next_state = state;
    next_direction = direction;

    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left && direction == LEFT) begin
                next_direction = RIGHT;
            end else if (bump_right && direction == RIGHT) begin
                next_direction = LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

assign walk_left = (state == WALKING && direction == LEFT);
assign walk_right = (state == WALKING && direction == RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule