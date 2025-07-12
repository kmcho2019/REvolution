module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// 5-bit maximal-length Galois LFSR with taps at positions 5 and 3 (1-based)
// Cycles through 31 states (2^5-1) before repeating
always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Active-high sync reset
    end
    else begin
        // MSB is q[0], tap at q[2] (position 3) XOR with q[0]
        q <= {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
    end
end

endmodule