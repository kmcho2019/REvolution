module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;   // Toggle direction on bump
        else
            next_state = state;    // Stay same direction
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore output logic
    always @(*) begin
        walk_left  = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
    end

endmodule