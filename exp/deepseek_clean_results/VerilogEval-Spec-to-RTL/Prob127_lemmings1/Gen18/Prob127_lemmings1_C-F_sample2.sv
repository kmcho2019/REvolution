module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;  // LEFT or RIGHT
    wire clk_enable = bump_left | bump_right;

    // State register with async reset and clock gating
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else if (clk_enable)
            state <= state ^ (state ? bump_right : bump_left);
    end

    // Output assignments
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule