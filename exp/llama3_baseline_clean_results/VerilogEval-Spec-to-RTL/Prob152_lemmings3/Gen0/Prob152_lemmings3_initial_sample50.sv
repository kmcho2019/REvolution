module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state, next_state;
parameter WALK_LEFT = 2'b00, WALK_RIGHT = 2'b01, FALL = 2'b10, DIG = 2'b11;

assign walk_left = (state == WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == WALK_RIGHT) ? 1'b1 : 1'b0;
assign aaah = (state == FALL) ? 1'b1 : 1'b0;
assign digging = (state == DIG) ? 1'b1 : 1'b0;

always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (bump_left) next_state = WALK_RIGHT;
            else if (bump_right) next_state = WALK_LEFT;
            else if (dig && ground) next_state = DIG;
            else if (!ground) next_state = FALL;
            else next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (bump_left) next_state = WALK_LEFT;
            else if (bump_right) next_state = WALK_RIGHT;
            else if (dig && ground) next_state = DIG;
            else if (!ground) next_state = FALL;
            else next_state = WALK_RIGHT;
        end
        FALL: begin
            if (ground) next_state = (bump_left) ? WALK_RIGHT : (bump_right) ? WALK_LEFT : (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
            else next_state = FALL;
        end
        DIG: begin
            if (!ground) next_state = FALL;
            else next_state = DIG;
        end
        default: next_state = WALK_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) state <= WALK_LEFT;
    else state <= next_state;
end

endmodule