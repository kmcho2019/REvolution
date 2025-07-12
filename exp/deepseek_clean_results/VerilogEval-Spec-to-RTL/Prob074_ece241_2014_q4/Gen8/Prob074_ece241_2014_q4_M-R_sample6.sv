module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_out, and_out, or_out;
    
    // XOR path: x XOR with its own output
    wire xor_in = x ^ xor_out;
    
    // AND path: x AND with complemented output
    wire and_in = x & ~and_out;
    
    // OR path: x OR with complemented output
    wire or_in = x | ~or_out;
    
    // Update flip-flops on clock edge
    always @(posedge clk) begin
        xor_out <= xor_in;
        and_out <= and_in;
        or_out <= or_in;
    end
    
    // Final NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule