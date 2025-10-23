module TopModule (
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

    reg state;

    // Next state logic as a combinational continuous assignment (wire)
    wire next_state = (bump_left & ~bump_right) ? WALK_RIGHT :  // bump left only
                      (~bump_left & bump_right) ? WALK_LEFT :  // bump right only
                      (bump_left & bump_right) ? ~state :     // bump both sides toggle
                      state;                                  // no bump hold

    // Sequential state register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore outputs driven from state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule