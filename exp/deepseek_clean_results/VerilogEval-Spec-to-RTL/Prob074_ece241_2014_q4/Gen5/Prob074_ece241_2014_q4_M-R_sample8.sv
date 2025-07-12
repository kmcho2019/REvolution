module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;
    
    // Feedback wires
    wire xor_fb, and_fb, or_fb;
    
    // Gate outputs (before flip-flops)
    wire xor_gate, and_gate, or_gate;
    
    // Initialize flip-flops to 0
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff = 1'b0;
    end
    
    // Feedback paths
    assign xor_fb = xor_ff;
    assign and_fb = ~and_ff;
    assign or_fb = ~or_ff;
    
    // Gate implementations
    assign xor_gate = x ^ xor_fb;
    assign and_gate = x & and_fb;
    assign or_gate = x | or_fb;
    
    // Sequential logic
    always @(posedge clk) begin
        xor_ff <= xor_gate;
        and_ff <= and_gate;
        or_ff <= or_gate;
    end
    
    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule