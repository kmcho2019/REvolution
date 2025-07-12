module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0=left, 1=right
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else if ((state == 0 && bump_left) || (state == 1 && bump_right))
            state <= ~state;
    end
    
    assign walk_left = ~state;
    assign walk_right = state;

endmodule