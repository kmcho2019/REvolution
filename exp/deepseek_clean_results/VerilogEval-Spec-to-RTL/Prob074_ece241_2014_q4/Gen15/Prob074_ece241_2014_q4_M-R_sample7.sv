module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff;
    reg and_ff;
    reg or_ff;
    
    // Reset signal (active high)
    reg reset = 1'b1;
    
    // Combinational logic outputs
    wire xor_out, and_out, or_out;
    
    // XOR path: x XOR previous xor_ff
    assign xor_out = x ^ xor_ff;
    
    // AND path: x AND NOT previous and_ff
    assign and_out = x & ~and_ff;
    
    // OR path: x OR NOT previous or_ff
    assign or_out = x | ~or_ff;
    
    always @(posedge clk) begin
        if (reset) begin
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
            reset <= 1'b0;
        end
        else begin
            xor_ff <= xor_out;
            and_ff <= and_out;
            or_ff  <= or_out;
        end
    end
    
    // Final NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule