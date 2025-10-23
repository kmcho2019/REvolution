module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// Fibonacci LFSR implementation with same polynomial as Galois version
// Taps at positions 5 and 3 (1-based) correspond to polynomial x^5 + x^3 + 1
// Feedback is XOR of bits 4 and 2 (0-based) with the LSB

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Active high sync reset to 1
    end else begin
        // Fibonacci LFSR implementation
        q <= {q[3] ^ q[1] ^ q[0], q[4:1]};
    end
end

endmodule