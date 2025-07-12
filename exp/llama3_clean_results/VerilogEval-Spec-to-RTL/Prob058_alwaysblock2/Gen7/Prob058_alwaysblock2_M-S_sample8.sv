// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    
    // Assign statement for out_assign
    assign out_assign = a ^ b;
    
    // Combinational always block for out_always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // Clocked always block for out_always_ff
    reg internal_out_always_ff;
    always_ff @(posedge clk) begin
        internal_out_always_ff <= a ^ b;
    end
    
    // Output of the clocked always block
    assign out_always_ff = internal_out_always_ff;
    
endmodule