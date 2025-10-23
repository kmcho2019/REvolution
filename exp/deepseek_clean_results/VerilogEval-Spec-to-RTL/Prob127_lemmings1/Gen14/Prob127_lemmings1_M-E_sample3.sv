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
    
    reg state;
    wire bump_both = bump_left & bump_right;
    wire direction_change = bump_both ? ~state : 
                          (bump_left ? RIGHT : 
                          (bump_right ? LEFT : state));

    // Dual-edge triggered state machine
    always @(posedge clk or posedge areset or negedge clk) begin
        if (areset) begin
            state <= LEFT;
        end
        else begin
            state <= direction_change;
        end
    end

    // Output logic remains combinational
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule