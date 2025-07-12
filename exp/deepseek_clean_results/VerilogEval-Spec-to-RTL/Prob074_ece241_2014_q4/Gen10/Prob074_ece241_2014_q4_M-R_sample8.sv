module TopModule (
    input clk,
    input x,
    output z
);

    // Combinational logic outputs
    wire xor_gate, and_gate, or_gate;
    
    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;
    
    // Gate computations
    assign xor_gate = x ^ xor_ff;
    assign and_gate = x & ~and_ff;
    assign or_gate  = x | ~or_ff;
    
    // Sequential logic - one always block per flip-flop
    always @(posedge clk) xor_ff <= xor_gate;
    always @(posedge clk) and_ff <= and_gate;
    always @(posedge clk) or_ff  <= or_gate;
    
    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule