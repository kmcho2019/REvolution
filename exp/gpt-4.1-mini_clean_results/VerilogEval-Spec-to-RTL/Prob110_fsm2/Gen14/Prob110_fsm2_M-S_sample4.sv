module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;          // OFF
        else if (state == 1'b0)
            state <= j ? 1'b1 : 1'b0;
        else
            state <= k ? 1'b0 : 1'b1;
    end

    always @(*) out = state;

endmodule