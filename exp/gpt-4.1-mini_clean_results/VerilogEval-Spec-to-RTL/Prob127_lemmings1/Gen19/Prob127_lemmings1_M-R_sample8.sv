module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Next state logic - combinational with case statement
    always @(*) begin
        case (state)
            WALK_LEFT:  next_state = bump_left ? WALK_RIGHT : WALK_LEFT;
            WALK_RIGHT: next_state = bump_right ? WALK_LEFT : WALK_RIGHT;
            default:    next_state = WALK_LEFT;  // safe default
        endcase
    end

    // State register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output assignments based on current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule