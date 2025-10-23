module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Async reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic: toggle state if any bump occurs
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // Moore output logic derived directly from state and its complement
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = ~walk_left;

endmodule