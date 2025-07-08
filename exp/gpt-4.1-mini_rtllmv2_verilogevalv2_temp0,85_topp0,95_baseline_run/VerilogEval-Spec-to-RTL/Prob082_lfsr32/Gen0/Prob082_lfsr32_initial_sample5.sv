module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    wire tap_bits_xor = q[31] ^ q[21] ^ q[1] ^ q[0];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Implement Galois LFSR shifting right
            // For bits with taps (31,21,1,0), next value is q[i+1] XOR feedback
            // For other bits, next value is just q[i+1]
            // q[31] is MSB, q[0] is LSB
            // We'll build next state into a temporary variable
            reg [31:0] next_q;
            next_q[31] = q[0] ^ q[21];        // Tap at 31, next_q[31] = q[0] xor q[21], but actually for Galois LFSR the feedback (q[0]) is XORed only at tapped bits. The next_q[31] comes from q[32], which does not exist; so for MSB, next_q[31] = q[31]'s tapped xor feedback means next_q[31] = q[0] ^ q[31]?
            // Wait, I need to be careful.

            // Actually, per Galois LFSR operation, the LFSR shifts right by one bit.
            // The bits shift right by one, but when bit i is a tap, the new bit i is old bit i+1 XOR feedback
            // For i < 31:
            // if i is tap: next_q[i] = q[i+1] ^ feedback
            // else: next_q[i] = q[i+1]
            // For i = 31 (MSB), next_q[31] = feedback (because there's no q[32])
            
            // So taps: 31, 21, 1, 0
            // But for i=31, next_q[31] = feedback since no bit beyond MSB
            // For i=21, next_q[21] = q[22] ^ feedback
            // For i=1, next_q[1] = q[2] ^ feedback
            // For i=0, next_q[0] = q[1] ^ feedback
            
            // But 0 is LSB, so next_q[0] = q[1] ^ feedback if tap at bit 1? Actually tap at bit 1 means position 1 (MSB=31, LSB=0), so bit 1 is q[1].
            // Wait the tap positions are 32,22,2,1, meaning bits 31,21,1,0 in zero-based indexing.
            // So taps at bits 31,21,1,0.
            // Then for each bit i:
            // if i == 31: next_q[31] = feedback
            // else if i in {21,1,0}: next_q[i] = q[i+1] ^ feedback
            // else: next_q[i] = q[i+1]
            
            // For i=31 (MSB), no q[32], so next_q[31] = feedback
            // For i < 31, next_q[i] depends on tap or not
            
            next_q[31] = feedback;
            for (i=0; i<31; i=i+1) begin
                if (i == 21 || i == 1 || i == 0)
                    next_q[i] = q[i+1] ^ feedback;
                else
                    next_q[i] = q[i+1];
            end
            q <= next_q;
        end
    end

endmodule