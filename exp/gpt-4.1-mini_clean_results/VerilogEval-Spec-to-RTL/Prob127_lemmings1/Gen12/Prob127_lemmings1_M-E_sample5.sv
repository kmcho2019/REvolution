module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam LEFT  = 1'b0;
    localparam RIGHT = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;  // Start walking left on reset
        end else begin
            if (bump_left | bump_right)
                state <= ~state; // Toggle direction on any bump
            else
                state <= state;   // Hold state if no bump
        end
    end

    // Moore outputs based on state
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule