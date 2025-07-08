module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    // Tap positions are bit 5 and bit 3. 
    // Indexing q[4:0] corresponds to bits 5 to 1.
    // On each clock, if reset is active, q is set to 5'b00001.
    // Otherwise, shift right by one bit, and for taps XOR with q[0].

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Extract feedback bit (LSB)
            wire feedback = q[0];

            // Next state calculation for each bit
            // q[4] = q[3] XOR feedback if tap (bit 5 is q[4])
            // q[2] = q[1] XOR feedback if tap (bit 3 is q[2])
            // others shift as normal
            q[4] <= q[3] ^ feedback; // tap at bit 5
            q[3] <= q[2];
            q[2] <= q[1] ^ feedback; // tap at bit 3
            q[1] <= q[0];
            q[0] <= feedback; // shifted out LSB becomes new MSB in Fibonacci, but in Galois it remains LSB, so q[0] is replaced by q[1]. But here in Galois, q[0] is shifted in from q[1], so just normal shift right. So q[0] <= q[0]'s predecessor which is q[1]
            // Correction: In Galois LFSR, shift right, q[0] is replaced by q[1].
            // So q[0] <= q[1]
            q[0] <= q[1];
        end
    end

endmodule