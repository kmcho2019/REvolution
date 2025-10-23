module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Parameters for tap positions
parameter TAP_32 = 31;  // MSB (position 32 in 1-based indexing)
parameter TAP_22 = 21;  // (position 22)
parameter TAP_2 = 1;    // (position 2)
parameter TAP_1 = 0;    // LSB (position 1)

// Registered feedback to break critical path
reg feedback_reg;
wire feedback = q[TAP_1];

// Clock gating control (could be external in real applications)
wire lfsr_enable = 1'b1;

always @(posedge clk) begin
    feedback_reg <= feedback;
    
    if (reset) begin
        q <= 32'h1;
    end
    else if (lfsr_enable) begin
        // Optimized Galois LFSR with registered feedback
        q <= {feedback_reg,
              q[TAP_32:TAP_22+1], 
              q[TAP_22] ^ feedback_reg,
              q[TAP_22-1:TAP_2+1],
              q[TAP_2] ^ feedback_reg,
              q[TAP_1] ^ feedback_reg};
    end
end

endmodule