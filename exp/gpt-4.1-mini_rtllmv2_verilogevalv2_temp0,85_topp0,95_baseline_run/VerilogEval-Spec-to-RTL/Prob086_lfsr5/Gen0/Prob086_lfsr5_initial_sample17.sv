module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);
    // Tap positions: bits 5 and 3 --> zero-based indices 4 and 2
    // For Galois LFSR, bit 0 is output bit, shifts right, taps are XORed with LSB before shifting in.

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // reset output to 1
        end else begin
            // Compute feedback
            // feedback = q[0] XOR q[2] (tap at bit 3)
            // Shift right with feedback applied at tapped bits
            // For Galois LFSR:
            // next q[4] = q[4] XOR feedback
            // next q[3] = q[3]
            // next q[2] = q[2] XOR feedback
            // next q[1] = q[1]
            // next q[0] = feedback

            wire feedback = q[0] ^ q[2];

            q[0] <= feedback;
            q[1] <= q[0];
            q[2] <= q[1] ^ feedback;
            q[3] <= q[2];
            q[4] <= q[3] ^ feedback;
        end
    end
endmodule