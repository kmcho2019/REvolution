module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0=OFF, 1=ON

    always @(posedge clk) begin
        if (reset)
            state <= 0;
        else if (state)
            state <= ~k;  // ON state: stay unless k=1
        else
            state <= j;   // OFF state: transition if j=1
    end

    assign out = state;

endmodule