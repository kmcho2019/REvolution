module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding parameters for readability
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state;

    // Next state logic (combinational)
    wire next_state;
    always @(*) begin
        if (state == WALK_RIGHT)
            next_state = bump_right ? WALK_LEFT : WALK_RIGHT;
        else
            next_state = bump_left ? WALK_RIGHT : WALK_LEFT;
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output assignments
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule