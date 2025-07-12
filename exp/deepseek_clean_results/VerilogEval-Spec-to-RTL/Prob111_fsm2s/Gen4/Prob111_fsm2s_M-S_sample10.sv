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
            state <= 1'b0;
        else
            state <= state ? ~k : j;
    end

    assign out = state;

endmodule