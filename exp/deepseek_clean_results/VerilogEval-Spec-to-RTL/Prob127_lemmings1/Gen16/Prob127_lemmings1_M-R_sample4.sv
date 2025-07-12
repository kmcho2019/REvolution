module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    localparam LEFT = 1'b0;
    localparam RIGHT = 1'b1;
    
    reg state;
    wire next_state;

    // Explicit state transition logic
    always @(*) begin
        case (state)
            LEFT:   next_state = bump_left ? RIGHT : LEFT;
            RIGHT:  next_state = bump_right ? LEFT : RIGHT;
            default: next_state = LEFT;
        endcase
    end

    // Edge-triggered state update with async reset
    assign #1 state = areset ? LEFT : 
                     (posedge clk ? next_state : state);

    // Combined output assignment
    assign {walk_left, walk_right} = (state == LEFT) ? 2'b10 : 
                                    (state == RIGHT) ? 2'b01 : 
                                    2'b00;

endmodule