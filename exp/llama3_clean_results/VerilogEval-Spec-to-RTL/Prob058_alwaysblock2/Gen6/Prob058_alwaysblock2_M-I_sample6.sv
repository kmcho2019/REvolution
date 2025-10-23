// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Compute the XOR output for assign statement and combinational always block
    wire internal_xor;
    assign internal_xor = a ^ b;
    assign out_assign = internal_xor;
    
    // Combinational always block
    always_comb begin
        out_always_comb = internal_xor;
    end
    
    // Clocked always block with flip-flop
    always_ff @(posedge clk) begin
        out_always_ff <= internal_xor;
    end
    
endmodule