module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Single bit state: 0=left, 1=right
    reg state;

    // State transition and output
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else if ((state == 0 && bump_left) || (state == 1 && bump_right))
            state <= ~state;
    end

    assign {walk_left, walk_right} = state ? 2'b01 : 2'b10;

endmodule