module TopModule (
    input clk,
    input x,
    output z
);

    // Main flip-flops
    reg xor_ff = 0;
    reg and_ff = 0;
    reg or_ff = 0;
    
    // Complemented flip-flop outputs for feedback
    reg and_fb_ff = 1;  // Initialized to 1 because ~0 = 1
    reg or_fb_ff = 1;   // Initialized to 1 because ~0 = 1

    // Gate inputs
    wire xor_in = x ^ xor_ff;
    wire and_in = x & and_fb_ff;
    wire or_in = x | or_fb_ff;

    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        // Main flip-flops
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
        
        // Feedback path flip-flops
        and_fb_ff <= ~and_ff;
        or_fb_ff <= ~or_ff;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule