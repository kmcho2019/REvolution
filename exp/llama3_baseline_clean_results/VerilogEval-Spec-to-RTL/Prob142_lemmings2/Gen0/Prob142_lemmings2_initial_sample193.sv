module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg [1:0] nextState;

// State encoding
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL = 2'b10;

always @(*) begin
    case(state)
        WALK_LEFT: begin
            if (bump_left)
                nextState = WALK_RIGHT;
            else if (bump_right)
                nextState = WALK_LEFT;
            else if (!ground)
                nextState = FALL;
            else
                nextState = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (bump_left)
                nextState = WALK_LEFT;
            else if (bump_right)
                nextState = WALK_RIGHT;
            else if (!ground)
                nextState = FALL;
            else
                nextState = WALK_RIGHT;
        end
        FALL: begin
            if (ground)
                nextState = (bump_left || bump_right)? (bump_left? WALK_LEFT : WALK_RIGHT) : state;
            else
                nextState = FALL;
        end
        default: nextState = WALK_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= nextState;
end

always @(*) begin
    case(state)
        WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
        end
        FALL: begin
            walk_left = 0;
            walk_right = 0;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
        end
    endcase
end

always @(*) begin
    if (state == FALL)
        aaah = 1;
    else
        aaah = 0;
end

endmodule