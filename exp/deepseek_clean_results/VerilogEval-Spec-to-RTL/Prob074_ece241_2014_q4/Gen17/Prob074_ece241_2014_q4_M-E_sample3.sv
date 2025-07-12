module TopModule (
    input clk,
    input x,
    output z
);

    // Combined 3-bit register for all states [xor, and, or]
    reg [2:0] state = 3'b000;
    
    // Feedback logic
    wire xor_fb = state[0];          // XOR feedback
    wire and_fb = ~state[1];         // AND feedback (complemented)
    wire or_fb  = ~state[2];         // OR feedback (complemented)
    
    // Gate computations
    wire next_xor = x ^ xor_fb;
    wire next_and = x & and_fb;
    wire next_or  = x | or_fb;
    
    // State update
    always @(posedge clk) begin
        state <= {next_or, next_and, next_xor};  // Pack in reverse order for easy indexing
    end
    
    // Final output - NOR of all state bits
    assign z = ~(|state);

endmodule