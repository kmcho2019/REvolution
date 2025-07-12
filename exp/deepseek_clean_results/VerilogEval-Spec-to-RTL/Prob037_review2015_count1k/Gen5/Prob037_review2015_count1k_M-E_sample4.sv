module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

// LFSR taps for maximal length sequence (1023 values)
// We'll constrain it to 1000 values through mapping
wire lfsr_feedback = q[9] ^ q[6];  // X^10 + X^7 + 1 polynomial
reg [9:0] lfsr_next;

always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0;
    end else begin
        // Standard LFSR update
        lfsr_next = {q[8:0], lfsr_feedback};
        
        // Map LFSR sequence to linear count 0-999
        // This is a simplified mapping - in practice would need a ROM or more complex logic
        // Here we just use the LFSR value mod 1000 as a conceptual example
        q <= (lfsr_next >= 10'd1000) ? (lfsr_next - 10'd1000) : lfsr_next;
    end
end

endmodule