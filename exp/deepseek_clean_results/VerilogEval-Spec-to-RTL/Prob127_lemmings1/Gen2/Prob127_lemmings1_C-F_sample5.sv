module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Named states for better readability
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;

    // Simplified state transition logic
    wire next_state = (state == LEFT) ? 
                     (bump_left ? RIGHT : LEFT) : 
                     (bump_right ? LEFT : RIGHT);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Clear output assignments
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule