module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // Reset to walk_left
        else begin
            case ({bump_left, bump_right})
                2'b11: state <= ~state;    // Both bumps: toggle direction
                2'b10: state <= 1'b1;      // Bumped left only: walk right
                2'b01: state <= 1'b0;      // Bumped right only: walk left
                default: state <= state;   // No bumps: hold state
            endcase
        end
    end

    // Moore outputs depend on current state only
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule