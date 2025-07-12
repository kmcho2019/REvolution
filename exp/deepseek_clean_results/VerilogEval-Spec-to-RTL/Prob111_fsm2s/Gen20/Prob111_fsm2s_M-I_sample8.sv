module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    reg state;  // 0=OFF, 1=ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            out <= 0;
        end
        else begin
            state <= state ? ~k : j;
            out <= state;
        end
    end

endmodule