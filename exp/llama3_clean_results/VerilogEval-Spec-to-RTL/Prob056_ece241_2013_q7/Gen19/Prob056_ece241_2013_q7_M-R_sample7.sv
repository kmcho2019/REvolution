module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Qold; // Internal signal to store the previous state of Q
assign Qold = Q; // Continuously update Qold with the current state of Q

always @(posedge clk) begin
    Q <= (~j & ~k) ? Q : 
         (~j & k) ? 1'b0 : 
         (j & ~k) ? 1'b1 : 
         ~Q; // Update Q based on the JK flip-flop truth table
end

endmodule