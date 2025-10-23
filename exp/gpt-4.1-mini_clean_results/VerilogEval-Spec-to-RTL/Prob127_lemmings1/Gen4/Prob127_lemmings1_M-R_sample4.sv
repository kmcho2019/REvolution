module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // Define states for clarity
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            WALK_LEFT:  // walking left
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT;  // switch to right on bump
                else
                    next_state = WALK_LEFT;
            WALK_RIGHT: // walking right
                if (bump_left || bump_right)
                    next_state = WALK_LEFT;   // switch to left on bump
                else
                    next_state = WALK_RIGHT;
            default:
                next_state = WALK_LEFT; // default safe state
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs as Moore machine outputs
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule