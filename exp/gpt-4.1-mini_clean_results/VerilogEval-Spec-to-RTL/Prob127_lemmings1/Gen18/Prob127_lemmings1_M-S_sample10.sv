module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    // Next state combinational logic: flip state if bumped on relevant side
    wire bump = bump_left | bump_right;
    wire next_state = bump ? ~state : state;

    // State register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Walk left
        else
            state <= next_state;
    end

    // Outputs derived directly from state
    assign walk_left  = (state == 1'b0);
    assign walk_right = (state == 1'b1);

endmodule