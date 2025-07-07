module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions (1-based): 32, 22, 2, 1
    // In 0-based indexing: 31, 21, 1, 0
    // Galois LFSR shifts right, feedback is XOR of q[0] and taps

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Calculate feedback bit
            // feedback = q[0] ^ q[31] ^ q[21] ^ q[1]
            wire feedback = q[0] ^ q[31] ^ q[21] ^ q[1];

            // Shift right by 1, and insert feedback at MSB
            q <= {feedback, q[31:1]};
        end
    end

endmodule