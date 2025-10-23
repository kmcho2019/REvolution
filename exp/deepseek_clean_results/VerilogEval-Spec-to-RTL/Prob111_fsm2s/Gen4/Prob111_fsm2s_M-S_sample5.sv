module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state; // 0=OFF, 1=ON

    always @(posedge clk) begin
        if (reset)
            state <= 0;
        else if (state == 0)
            state <= j;
        else
            state <= ~k;
    end

    assign out = state;

endmodule