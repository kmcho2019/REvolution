module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 0 // Initialize Q to 0 for predictable behavior
);

reg Qold = 0; // Store the previous state of Q

always @(posedge clk) begin
    Qold <= Q; // Update Qold at the positive clock edge
end

assign Q = (j == 1'b0 && k == 1'b0) ? Qold : // No change
           (j == 1'b0 && k == 1'b1) ? 1'b0 : // Reset
           (j == 1'b1 && k == 1'b0) ? 1'b1 : // Set
           (j == 1'b1 && k == 1'b1) ? ~Qold : Qold; // Toggle

endmodule