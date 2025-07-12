module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    always @(posedge clk) begin
        if (reset)      out <= 0;
        else if (out)    out <= ~k;
        else            out <= j;
    end

endmodule