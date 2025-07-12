module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Corrected tap positions considering 0-indexing
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to the specified initial value
        q <= 32'h1;
    end else begin
        // Calculate the feedback bit as the XOR of the taps and the LSB
        reg [31:0] next_q;
        reg feedback = q[0] ^ q[1] ^ q[2] ^ q[21] ^ q[31];
        
        // Generate the next state by shifting right and applying feedback
        next_q[31] = feedback;
        next_q[21:2] = q[20:1];
        next_q[1] = feedback;
        next_q[0] = q[31] ^ q[21] ^ q[2] ^ q[1];
        
        // But according to Galois LFSR rule, bits which don't have tap
        // simply get the bit from the left, only tapped bits get 
        // influenced by the feedback.
        next_q[30:22] = q[29:21];
        next_q[20:2] = q[19:1];
        
        // Apply the next state
        q <= next_q;
    end
end

endmodule