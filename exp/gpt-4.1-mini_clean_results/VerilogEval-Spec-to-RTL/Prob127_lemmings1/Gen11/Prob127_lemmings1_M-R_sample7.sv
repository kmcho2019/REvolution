module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding: bit0 = walk_left, bit1 = walk_right
    localparam [1:0]
        WALK_LEFT  = 2'b01,
        WALK_RIGHT = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic using assign (combinational)
    wire bump_l = bump_left;
    wire bump_r = bump_right;

    assign next_state =
        (state == WALK_LEFT)  ? ((bump_r || bump_l) ? WALK_RIGHT : WALK_LEFT) :
        (state == WALK_RIGHT) ? ((bump_l || bump_r) ? WALK_LEFT : WALK_RIGHT) :
                                WALK_LEFT; // default to WALK_LEFT

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs directly from state bits (Moore)
    assign walk_left  = state[0];
    assign walk_right = state[1];

endmodule