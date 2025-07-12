module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state; // 0: OFF, 1: ON

    assign out = state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // OFF
        else if (state == 1'b0)
            state <= j ? 1'b1 : 1'b0;
        else
            state <= k ? 1'b0 : 1'b1;
    end

endmodule