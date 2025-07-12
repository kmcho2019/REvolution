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

    // State update with asynchronous reset and output assignment
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= WALK_LEFT;
        end
        else begin
            case (state_reg)
                WALK_LEFT:  state_reg <= bump_left ? WALK_RIGHT : WALK_LEFT;
                WALK_RIGHT: state_reg <= bump_right ? WALK_LEFT : WALK_RIGHT;
            endcase
        end
    end

    // Direct output assignment from state register
    assign walk_left = ~state_reg;  // Equivalent to (state_reg == WALK_LEFT)
    assign walk_right = state_reg;  // Equivalent to (state_reg == WALK_RIGHT)

endmodule