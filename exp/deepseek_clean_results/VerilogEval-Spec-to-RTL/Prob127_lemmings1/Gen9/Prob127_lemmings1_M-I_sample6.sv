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
    
    reg state_reg;

    // State transition logic
    wire next_state = (state_reg == WALK_LEFT) ? 
                     (bump_left ? WALK_RIGHT : WALK_LEFT) :
                     (bump_right ? WALK_LEFT : WALK_RIGHT);

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state_reg <= WALK_LEFT;
        else
            state_reg <= next_state;
    end

    // Output logic - directly from state register
    assign walk_left = ~state_reg;
    assign walk_right = state_reg;

endmodule