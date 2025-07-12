module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// Optimized parallel computation with explicit XOR
wire feedback = q[0];
wire [4:0] next_q = {
    feedback,            // x^5 term (MSB gets feedback)
    q[4],               // Simple shift
    q[3] ^ feedback,    // x^3 term (tap position)
    q[2],               // Simple shift
    q[1]                // Simple shift
};

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Initialize to non-zero state
    end
    else begin
        q <= next_q;     // Update state in parallel
    end
end

endmodule