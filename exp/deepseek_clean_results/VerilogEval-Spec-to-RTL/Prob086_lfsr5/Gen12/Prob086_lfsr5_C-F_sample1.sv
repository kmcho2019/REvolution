module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[4] ^ q[2];  // Taps at positions 5 and 3 (1-based) or 4 and 2 (0-based)

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Active high synchronous reset to 1
    end else begin
        // Galois LFSR implementation:
        // MSB comes from feedback, other bits shift right
        // q[0] is XORed with taps to generate feedback
        q <= {feedback, q[4:1]};
    end
end

endmodule