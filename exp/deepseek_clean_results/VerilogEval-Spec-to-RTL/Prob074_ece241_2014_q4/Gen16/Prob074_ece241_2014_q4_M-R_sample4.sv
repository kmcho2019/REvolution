module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_out, and_out, or_out;
    
    // Combinational logic outputs before flip-flops
    wire xor_gate, and_gate, or_gate;
    
    // XOR gate with feedback from its flip-flop
    assign xor_gate = x ^ xor_out;
    
    // AND gate with feedback from complemented flip-flop
    assign and_gate = x & ~and_out;
    
    // OR gate with feedback from complemented flip-flop
    assign or_gate = x | ~or_out;
    
    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        xor_out <= xor_gate;
        and_out <= and_gate;
        or_out <= or_gate;
    end
    
    // Final three-input NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule