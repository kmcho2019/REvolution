module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;

// Optimized parallel computation with clear polynomial representation
assign next_q = {
    q[0],                // x^5 term (MSB gets feedback)
    q[4],                // Simple shift
    q[3] ^ q[0],         // x^3 term (tap position)
    q[2],                // Simple shift
    q[1]                 // Simple shift
};

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;   // Initialize to non-zero state
    end
    else begin
        q <= next_q;     // Update state in parallel
    end
end

endmodule