module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always @(posedge clk) begin
    if (reset) out <= 0; // Reset to OFF state
    else if (~out && j) out <= 1; // Transition from OFF to ON
    else if (out && k) out <= 0; // Transition from ON to OFF
end

endmodule