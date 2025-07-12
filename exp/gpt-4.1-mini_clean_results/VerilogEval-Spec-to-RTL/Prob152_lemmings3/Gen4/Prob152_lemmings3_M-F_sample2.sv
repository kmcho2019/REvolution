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

// State encoding
localparam WALK_LEFT   = 3'd0;
localparam WALK_RIGHT  = 3'd1;
localparam FALL_LEFT   = 3'd2;
localparam FALL_RIGHT  = 3'd3;
localparam DIG_LEFT    = 3'd4;
localparam DIG_RIGHT   = 3'd5;

reg [2:0] state, next_state;

// Combinational next state logic
always @(*) begin
    case(state)
        // Walking left
        WALK_LEFT: begin
            if (!ground)
                next_state = FALL_LEFT;
            else if (dig)
                next_state = DIG_LEFT;
            else if (bump_left || bump_right)
                next_state = WALK_RIGHT;
            else
                next_state = WALK_LEFT;
        end

        // Walking right
        WALK_RIGHT: begin
            if (!ground)
                next_state = FALL_RIGHT;
            else if (dig)
                next_state = DIG_RIGHT;
            else if (bump_left || bump_right)
                next_state = WALK_LEFT;
            else
                next_state = WALK_RIGHT;
        end

        // Falling left
        FALL_LEFT: begin
            if (ground)
                next_state = WALK_LEFT;
            else
                next_state = FALL_LEFT;
        end

        // Falling right
        FALL_RIGHT: begin
            if (ground)
                next_state = WALK_RIGHT;
            else
                next_state = FALL_RIGHT;
        end

        // Digging left
        DIG_LEFT: begin
            if (!ground)
                next_state = FALL_LEFT;
            else
                next_state = DIG_LEFT;
        end

        // Digging right
        DIG_RIGHT: begin
            if (!ground)
                next_state = FALL_RIGHT;
            else
                next_state = DIG_RIGHT;
        end

        default: next_state = WALK_LEFT; // default safe state
    endcase
end

// Sequential state update with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

// Moore outputs
assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule