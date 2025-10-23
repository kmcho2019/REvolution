module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];  // The feedback is always the LSB in Galois LFSR

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Galois LFSR with taps at positions 5 and 3 (1-based)
        q <= {q[3] ^ (feedback & 1'b1),  // Position 4 (0-based) - tap at 5 (1-based)
              q[2] ^ (feedback & 1'b1),  // Position 2 (0-based) - tap at 3 (1-based)
              q[1],
              q[0],
              q[4]};  // MSB becomes new LSB
    end
end

endmodule