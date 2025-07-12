module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state, next_state;
parameter WALK_LEFT = 2'b00, WALK_RIGHT = 2'b01, FALLING = 2'b10;

always @(*) begin
    case(state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            if (bump_left) next_state = WALK_RIGHT;
            else if (bump_right) next_state = WALK_RIGHT;
            else if (!ground) next_state = FALLING;
            else next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            if (bump_left) next_state = WALK_LEFT;
            else if (bump_right) next_state = WALK_LEFT;
            else if (!ground) next_state = FALLING;
            else next_state = WALK_RIGHT;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if (ground) begin
                if (bump_left || bump_right) begin
                    if (state == WALK_LEFT) next_state = WALK_RIGHT;
                    else if (state == WALK_RIGHT) next_state = WALK_LEFT;
                end else begin
                    next_state = state == WALK_LEFT ? WALK_LEFT : WALK_RIGHT;
                end
            end else next_state = FALLING;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) state <= WALK_LEFT;
    else state <= next_state;
end

endmodule