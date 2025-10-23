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
    wire clk_enable = (state == LEFT) ? bump_left : bump_right;
    wire next_state = ~state;  // Simple toggle when enabled

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else if (clk_enable)
            state <= next_state;
    end

    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule