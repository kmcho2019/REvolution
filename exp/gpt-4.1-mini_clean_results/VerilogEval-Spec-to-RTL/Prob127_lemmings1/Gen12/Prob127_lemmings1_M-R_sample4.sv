module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = WALK_LEFT, 1 = WALK_RIGHT
    reg state;

    // Next state combinational logic using a single expression:
    // If any bump is active, flip state; else keep current state
    wire bump = bump_left | bump_right;
    wire next_state = bump ? ~state : state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // WALK_LEFT
        else
            state <= next_state;
    end

    // Outputs directly assigned from state
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule