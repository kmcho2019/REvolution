module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam WALK_LEFT = 1'b0;
    localparam WALK_RIGHT = 1'b1;
    
    reg state;
    wire next_state;

    // Next state logic using continuous assignment
    assign next_state = (areset) ? WALK_LEFT :
                       (state == WALK_LEFT && bump_left) ? WALK_RIGHT :
                       (state == WALK_RIGHT && bump_right) ? WALK_LEFT :
                       state;

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output assignments
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule