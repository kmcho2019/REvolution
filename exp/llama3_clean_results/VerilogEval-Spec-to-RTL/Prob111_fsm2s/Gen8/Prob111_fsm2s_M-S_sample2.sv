module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 0;
    end else if (out) begin
        out <= !k;
    end else begin
        out <= j;
    end
end

endmodule