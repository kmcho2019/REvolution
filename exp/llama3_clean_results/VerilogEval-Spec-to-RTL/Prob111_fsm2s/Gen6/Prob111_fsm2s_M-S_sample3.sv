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
    end else if (j && !out) begin
        out <= 1;
    end else if (k && out) begin
        out <= 0;
    end
end

endmodule