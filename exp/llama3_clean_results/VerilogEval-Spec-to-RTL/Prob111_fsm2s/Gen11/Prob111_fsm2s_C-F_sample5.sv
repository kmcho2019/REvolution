module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 1'b0; // Reset to OFF state
    end else begin
        // Simplified state transition logic
        out <= (out == 1'b0) ? j : (out == 1'b1) ? ~k : out;
    end
end

endmodule