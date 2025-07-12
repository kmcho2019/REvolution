module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 0 // Initialize Q to 0 for predictable behavior
);

always @(posedge clk) begin
    Q <= (j == 1'b0 && k == 1'b0) ? Q : // No change
         (j == 1'b0 && k == 1'b1) ? 1'b0 : // Reset
         (j == 1'b1 && k == 1'b0) ? 1'b1 : // Set
         (j == 1'b1 && k == 1'b1) ? ~Q : Q; // Toggle
end

endmodule