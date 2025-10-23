module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output reg out  // output
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        out <= 1'b0;
    end else begin
        out <= (out == 1'b0) ? j : ~k;
    end
end

endmodule