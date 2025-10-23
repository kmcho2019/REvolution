module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding: bit1 = falling, bit0 = direction
    localparam WALK_LEFT  = 2'b00; // falling=0, direction=0
    localparam WALK_RIGHT = 2'b01; // falling=0, direction=1
    localparam FALL_LEFT  = 2'b10; // falling=1, direction=0
    localparam FALL_RIGHT = 2'b11; // falling=1, direction=1

    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
                else if (bump_left && bump_right)
                    next_state = WALK_RIGHT; // flip direction
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT; // includes bump_right = 0 or 1 no change
            end

            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
                else if (bump_left && bump_right)
                    next_state = WALK_LEFT; // flip direction
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT; // includes bump_left=0 or 1 no change
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

            default: next_state = WALK_LEFT; // safety fallback
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs decoded from current state
    assign aaah       = state[1];            // falling bit
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule