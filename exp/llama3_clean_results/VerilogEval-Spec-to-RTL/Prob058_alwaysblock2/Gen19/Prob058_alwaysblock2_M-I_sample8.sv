// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Calculate XOR once and reuse for out_assign and out_always_comb
    wire xor_out = a ^ b;
    
    assign out_assign = xor_out;
    assign out_always_comb = xor_out;
    
    // Update out_always_ff only on the positive edge of the clock
    always_ff @(posedge clk) begin
        out_always_ff <= xor_out; // Use the pre-calculated XOR result
    end
    
endmodule