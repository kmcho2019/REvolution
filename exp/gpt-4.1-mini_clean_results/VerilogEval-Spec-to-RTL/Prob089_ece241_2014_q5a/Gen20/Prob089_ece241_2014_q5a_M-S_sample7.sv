module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    reg state; // 0: before first '1', 1: after first '1'

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else if (state == 1'b0 && x == 1'b1)
            state <= 1'b1;
    end

    assign z = (state == 1'b0) ? x : ~x;

endmodule