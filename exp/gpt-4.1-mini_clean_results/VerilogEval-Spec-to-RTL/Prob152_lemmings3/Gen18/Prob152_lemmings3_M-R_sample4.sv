module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

localparam WALK_LEFT  = 3'd0,
           WALK_RIGHT = 3'd1,
           FALL_LEFT  = 3'd2,
           FALL_RIGHT = 3'd3,
           DIG_LEFT   = 3'd4,
           DIG_RIGHT  = 3'd5;

reg [2:0] state, state_next;

always @(*) begin
    state_next = state; // default hold state

    case (state)
        WALK_LEFT: begin
            if (!ground)
                state_next = FALL_LEFT;
            else if (dig)
                state_next = DIG_LEFT;
            else if (bump_left || bump_right)
                state_next = WALK_RIGHT;
        end
        WALK_RIGHT: begin
            if (!ground)
                state_next = FALL_RIGHT;
            else if (dig)
                state_next = DIG_RIGHT;
            else if (bump_left || bump_right)
                state_next = WALK_LEFT;
        end
        FALL_LEFT: begin
            if (ground)
                state_next = WALK_LEFT;
        end
        FALL_RIGHT: begin
            if (ground)
                state_next = WALK_RIGHT;
        end
        DIG_LEFT: begin
            if (!ground)
                state_next = FALL_LEFT;
        end
        DIG_RIGHT: begin
            if (!ground)
                state_next = FALL_RIGHT;
        end
        default: state_next = WALK_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= state_next;
end

assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule