module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;
    
    // Combinational logic outputs before flip-flops
    wire xor_gate, and_gate, or_gate;
    
    // XOR gate with feedback from its flip-flop output
    assign xor_gate = x ^ xor_ff;
    
    // AND gate with feedback from complemented flip-flop output
    assign and_gate = x & ~and_ff;
    
    // OR gate with feedback from complemented flip-flop output
    assign or_gate = x | ~or_ff;
    
    // Sequential logic (flip-flops) with synchronous reset
    always @(posedge clk) begin
        xor_ff <= xor_gate;
        and_ff <= and_gate;
        or_ff <= or_gate;
    end
    
    // Final three-input NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule