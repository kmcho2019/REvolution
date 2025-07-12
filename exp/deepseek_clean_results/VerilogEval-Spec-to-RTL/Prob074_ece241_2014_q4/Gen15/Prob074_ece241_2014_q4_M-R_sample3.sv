module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_out, and_out, or_out;
    
    // Intermediate gate outputs
    wire xor_gate, and_gate, or_gate;
    
    // Combinational gate logic
    assign xor_gate = x ^ xor_out;      // XOR with flip-flop output
    assign and_gate = x & ~and_out;     // AND with complemented flip-flop output
    assign or_gate  = x | ~or_out;      // OR with complemented flip-flop output
    
    // Sequential flip-flops
    always @(posedge clk) begin
        xor_out <= xor_gate;
        and_out <= and_gate;
        or_out  <= or_gate;
    end
    
    // Output NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule