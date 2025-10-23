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

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else case (state)
            LEFT:  state <= bump_left ? RIGHT : LEFT;
            RIGHT: state <= bump_right ? LEFT : RIGHT;
        endcase
    end

    // Direct output assignments for minimal logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule