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

    // State transitions with asynchronous reset
    // Priority: bump_left -> walk right, bump_right -> walk left
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            if (bump_left)
                state <= WALK_RIGHT;
            else if (bump_right)
                state <= WALK_LEFT;
            else
                state <= state; // Hold current state if no bumps
        end
    end

    // Moore output
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule