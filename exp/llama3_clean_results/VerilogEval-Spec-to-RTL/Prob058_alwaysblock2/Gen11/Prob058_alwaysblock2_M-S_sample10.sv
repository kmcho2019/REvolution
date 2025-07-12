// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Implement XOR gate using assign
    assign out_assign = a ^ b;
    
    // Implement XOR gate using combinational always block
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // Implement XOR gate using clocked always block
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b; // Use non-blocking assignment to prevent race conditions
    end
    
endmodule