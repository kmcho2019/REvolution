module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state for predictable behavior
);

always @(posedge clk) begin
    Q <= (j && k) ? ~Q : // Toggle when both j and k are 1
         (~j && k) ? 1'b0 : // Reset when j is 0 and k is 1
         (j && ~k) ? 1'b1 : // Set when j is 1 and k is 0
         Q; // No change when both j and k are 0
end

endmodule