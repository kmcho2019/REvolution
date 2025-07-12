module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg q_xor, q_and, q_or;
    
    // Gate outputs (before flip-flops)
    wire d_xor, d_and, d_or;
    
    // Feedback connections
    wire fb_xor = q_xor;
    wire fb_and = ~q_and;
    wire fb_or = ~q_or;
    
    // Gate implementations
    assign d_xor = x ^ fb_xor;       // XOR with its flip-flop output
    assign d_and = x & fb_and;       // AND with complemented flip-flop output
    assign d_or = x | fb_or;         // OR with complemented flip-flop output
    
    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or <= d_or;
    end
    
    // Final output NOR gate
    assign z = ~(q_xor | q_and | q_or);

endmodule