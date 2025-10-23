module TopModule (
    input clk,
    input x,
    output z
);

    // Combinational logic outputs
    wire xor_out, and_out, or_out;
    
    // Flip-flop outputs
    reg xor_ff = 0, and_ff = 0, or_ff = 0;
    
    // XOR path: x XOR previous xor_ff
    assign xor_out = x ^ xor_ff;
    
    // AND path: x AND NOT previous and_ff
    assign and_out = x & ~and_ff;
    
    // OR path: x OR NOT previous or_ff
    assign or_out = x | ~or_ff;
    
    // Register all paths
    always @(posedge clk) begin
        xor_ff <= xor_out;
        and_ff <= and_out;
        or_ff  <= or_out;
    end
    
    // Final NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule