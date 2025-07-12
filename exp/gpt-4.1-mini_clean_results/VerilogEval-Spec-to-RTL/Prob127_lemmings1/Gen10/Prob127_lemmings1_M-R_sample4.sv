module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    // State register and next state logic combined
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk_left on reset
        else begin
            if (bump_left && bump_right)
                state <= ~state;         // bump both sides: invert direction
            else if (bump_left)
                state <= 1'b1;           // bump_left → walk_right
            else if (bump_right)
                state <= 1'b0;           // bump_right → walk_left
            else
                state <= state;          // no bump: remain in current state
        end
    end

    // Moore outputs directly from state
    assign walk_left  = (state == 1'b0);
    assign walk_right = (state == 1'b1);

endmodule