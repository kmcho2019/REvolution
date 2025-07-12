// Define a single module for the TopModule
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Use assign statements for the combinational XOR gates
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;
    
    // Use a single always block for the clocked XOR gate
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b; // Use non-blocking assignment to prevent race conditions
    end
    
endmodule