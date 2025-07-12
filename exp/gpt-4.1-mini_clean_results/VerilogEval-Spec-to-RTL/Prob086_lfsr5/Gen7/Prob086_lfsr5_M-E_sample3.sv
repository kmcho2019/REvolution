module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // reset to 1
    end else begin
        wire feedback = q[0];
        // Galois LFSR taps at bits 5 and 3 correspond to q[4] and q[2]
        // For Galois LFSR, the bits with taps xor with feedback when shifted in.
        // Shift right by 1 bit, then xor tap bits with feedback

        q <= { (q[4] ^ feedback),      // new q[4] = old q[4] xor feedback
               q[4],                  // new q[3] = old q[4]
               (q[2] ^ feedback),      // new q[2] = old q[2] xor feedback
               q[2],                  // new q[1] = old q[2]
               q[1] };                // new q[0] = old q[1]
    end
end

endmodule