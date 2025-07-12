module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 0; // Reset to OFF state
    end else begin
        out <= (out && !k) || (!out && j); // Transition based on inputs
    end
end

endmodule