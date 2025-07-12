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

// Define states encoding both behavior and direction (3 bits)
localparam WALK_LEFT  = 3'd0;
localparam WALK_RIGHT = 3'd1;
localparam FALL_LEFT  = 3'd2;
localparam FALL_RIGHT = 3'd3;
localparam DIG_LEFT   = 3'd4;
localparam DIG_RIGHT  = 3'd5;

reg [2:0] state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

always @(*) begin
    next_state = state; // default hold state

    case(state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALL_LEFT;
            end else if (dig) begin
                next_state = DIG_LEFT;
            end else if (bump_left && bump_right) begin
                next_state = WALK_RIGHT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else if (dig) begin
                next_state = DIG_RIGHT;
            end else if (bump_left && bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end

        FALL_LEFT: begin
            if (ground)
                next_state = WALK_LEFT;
            else
                next_state = FALL_LEFT;
        end

        FALL_RIGHT: begin
            if (ground)
                next_state = WALK_RIGHT;
            else
                next_state = FALL_RIGHT;
        end

        DIG_LEFT: begin
            if (!ground)
                next_state = FALL_LEFT;
            else
                next_state = DIG_LEFT;
        end

        DIG_RIGHT: begin
            if (!ground)
                next_state = FALL_RIGHT;
            else
                next_state = DIG_RIGHT;
        end

        default: next_state = WALK_LEFT; // fallback
    endcase
end

assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule