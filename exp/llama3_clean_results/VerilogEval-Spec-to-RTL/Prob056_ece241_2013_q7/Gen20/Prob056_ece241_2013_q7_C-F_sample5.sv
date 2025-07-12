module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state for simulation and synthesis
);

always @(posedge clk) begin
    // Simplified expression for the JK flip-flop truth table, following the direct approach
    Q <= (~j & ~k) ? Q : 
         (~j & k) ? 1'b0 : 
         (j & ~k) ? 1'b1 : 
         ~Q; // Utilize the direct computation of the next state based on current Q and inputs
end

endmodule