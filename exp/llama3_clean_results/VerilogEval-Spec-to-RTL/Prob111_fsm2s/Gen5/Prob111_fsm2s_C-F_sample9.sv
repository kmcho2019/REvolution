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
        out <= (out && !k) || (!out && j); // Directly encode state transitions
    end
end

endmodule