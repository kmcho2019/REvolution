`define STATE_WALK 2'b00
`define STATE_FALL 2'b01
`define STATE_DIG 2'b10

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

enum logic [1:0] {STATE_WALK, STATE_FALL, STATE_DIG} state, next_state;
enum logic {DIR_LEFT, DIR_RIGHT} direction, next_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_WALK;
        direction <= DIR_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        direction <= next_direction;
        if (next_state == STATE_WALK) begin
            if (next_direction == DIR_LEFT) begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            aaah <= 1'b0;
            digging <= 1'b0;
        end else if (next_state == STATE_FALL) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
        end else if (next_state == STATE_DIG) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
        end
    end
end

always_comb begin
    next_state = state;
    next_direction = direction;
    case (state)
        STATE_WALK: begin
            if (!ground) begin
                next_state = STATE_FALL;
            end else if (dig) begin
                next_state = STATE_DIG;
            end else if (bump_left && direction == DIR_LEFT) begin
                next_direction = DIR_RIGHT;
            end else if (bump_right && direction == DIR_RIGHT) begin
                next_direction = DIR_LEFT;
            end
        end
        STATE_FALL: begin
            if (ground) begin
                next_state = STATE_WALK;
            end
        end
        STATE_DIG: begin
            if (!ground) begin
                next_state = STATE_FALL;
            end
        end
    endcase
end

endmodule