module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always_ff @(posedge clk) begin
    if (reset) begin
        out <= 1'b0; // Reset to OFF state
    end else if (out == 1'b0 && j == 1'b1) begin
        out <= 1'b1; // Transition to ON if j is 1
    end else if (out == 1'b1 && k == 1'b1) begin
        out <= 1'b0; // Transition to OFF if k is 1
    end
end

endmodule