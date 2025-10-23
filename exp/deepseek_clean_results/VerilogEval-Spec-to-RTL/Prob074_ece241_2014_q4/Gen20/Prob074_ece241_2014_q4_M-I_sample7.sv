module TopModule (
    input clk,
    input x,
    output z
);

    // Individual flip-flops
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;
    
    // Intermediate gate outputs
    wire xor_gate, and_gate, or_gate;
    
    // XOR gate with feedback from its flip-flop
    assign xor_gate = x ^ xor_ff;
    
    // AND gate with feedback from complemented flip-flop
    assign and_gate = x & ~and_ff;
    
    // OR gate with feedback from complemented flip-flop
    assign or_gate = x | ~or_ff;
    
    always @(posedge clk) begin
        xor_ff <= xor_gate;
        and_ff <= and_gate;
        or_ff <= or_gate;
    end
    
    // NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule