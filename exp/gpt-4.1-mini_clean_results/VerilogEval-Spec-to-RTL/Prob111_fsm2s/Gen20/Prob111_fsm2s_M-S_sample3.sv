module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;  // OFF state
        else if (!out)
            out <= j;
        else
            out <= ~k ? 1'b1 : 1'b0;
    end

endmodule