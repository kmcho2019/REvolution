module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Define states
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;
    
    reg state;
    wire next_state;

    // Next state logic using continuous assignment
    assign next_state = (state == WALK_LEFT) ? 
                        (bump_left ? WALK_RIGHT : WALK_LEFT) :
                        (bump_right ? WALK_LEFT : WALK_RIGHT);

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule