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

    // Next state logic - simplified:
    // Flip direction if bumped on the side it's currently walking towards.
    // When walking left, bump_left flips to walk right.
    // When walking right, bump_right flips to walk left.
    // If bumped on both sides at once, still flip.
    always @(*) begin
        if (state == WALK_LEFT) begin
            next_state = bump_left ? WALK_RIGHT : WALK_LEFT;
        end else begin
            next_state = bump_right ? WALK_LEFT : WALK_RIGHT;
        end
    end

    // State register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Generate one output directly and the other by inversion to reduce output drivers
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = ~walk_left;

endmodule