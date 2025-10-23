module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Next-state logic combinational block
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                // If bumped on left or both, go right; else stay left
                if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                // If bumped on right or both, go left; else stay right
                if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State register with asynchronous posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output logic combinational block (Moore outputs)
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
            end
            WALK_RIGHT: begin
                walk_left  = 1'b0;
                walk_right = 1'b1;
            end
            default: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
            end
        endcase
    end

endmodule