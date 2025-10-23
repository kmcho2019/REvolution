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

    // Async reset and state update on clock
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else if (bump_left | bump_right)
            state <= ~state; // toggle state on any bump
        else
            state <= state;   // hold state otherwise
    end

    // Moore output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule