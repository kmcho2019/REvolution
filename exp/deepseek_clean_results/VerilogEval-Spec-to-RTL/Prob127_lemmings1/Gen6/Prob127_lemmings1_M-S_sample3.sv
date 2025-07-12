module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;
    
    reg state;

    // Combined state transition and register logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else case (state)
            WALK_LEFT:  state <= bump_left ? WALK_RIGHT : WALK_LEFT;
            WALK_RIGHT: state <= bump_right ? WALK_LEFT : WALK_RIGHT;
        endcase
    end

    // Output logic (Moore style)
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule