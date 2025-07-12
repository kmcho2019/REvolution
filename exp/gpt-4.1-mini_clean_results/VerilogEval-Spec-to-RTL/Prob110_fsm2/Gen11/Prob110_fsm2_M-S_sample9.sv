module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= (state == 1'b0) ? j : ~k;
    end

    assign out = state;

endmodule