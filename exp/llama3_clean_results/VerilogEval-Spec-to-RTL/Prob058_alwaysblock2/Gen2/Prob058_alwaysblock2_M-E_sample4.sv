module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Internal wire to store the result of the XOR operation
    wire internal_xor;
    
    // Combinational always block to compute the XOR
    always @(*) begin
        internal_xor = a ^ b;
        out_always_comb = internal_xor;
    end
    
    // Assign statement for immediate output
    assign out_assign = internal_xor;
    
    // Clocked always block for the flip-flop
    always @(posedge clk) begin
        out_always_ff = internal_xor;
    end
    
endmodule