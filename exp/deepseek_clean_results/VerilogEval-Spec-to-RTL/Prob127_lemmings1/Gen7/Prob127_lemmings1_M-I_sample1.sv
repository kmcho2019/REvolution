module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding using localparam
    localparam WALK_LEFT = 1'b0;
    localparam WALK_RIGHT = 1'b1;
    
    reg state;

    // State register with asynchronous reset and direct next state computation
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= (state == WALK_LEFT) ? 
                    (bump_left ? WALK_RIGHT : WALK_LEFT) :
                    (bump_right ? WALK_LEFT : WALK_RIGHT);
    end

    // Output logic - direct state comparison
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule