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

    // Next state combinational logic using continuous assignment
    wire next_state = (bump_left & ~bump_right) ? WALK_RIGHT :
                      (~bump_left & bump_right) ? WALK_LEFT :
                      (bump_left & bump_right) ? ~state :
                      state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs as combinational assignments from state (Moore outputs)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule