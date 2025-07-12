module TopModule (
    input clk,
    input x,
    output z
);

    // Declare flip-flop outputs
    wire xor_out, and_out, or_out;
    
    // Declare flip-flop inputs (gate outputs)
    wire xor_gate_out, and_gate_out, or_gate_out;
    
    // XOR path: x XOR with its flip-flop's output
    assign xor_gate_out = x ^ xor_out;
    
    // AND path: x AND with its flip-flop's complemented output
    assign and_gate_out = x & (~and_out);
    
    // OR path: x OR with its flip-flop's complemented output
    assign or_gate_out = x | (~or_out);
    
    // D Flip-flops (synchronous, initially 0)
    always @(posedge clk) begin
        xor_out <= xor_gate_out;
        and_out <= and_gate_out;
        or_out <= or_gate_out;
    end
    
    // Final NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule