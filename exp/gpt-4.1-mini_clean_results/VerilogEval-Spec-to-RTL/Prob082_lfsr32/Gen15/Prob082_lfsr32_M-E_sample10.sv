module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Calculate feedback bit from taps XORed with q[0]
            // Taps at bits: 31 (bit 32), 21 (bit 22), 1 (bit 2), and 0 (bit 1)
            wire feedback = q[0] ^ q[31] ^ q[21] ^ q[1] ^ q[0];
            // Note: q[0] is included twice to represent the tap at bit 1 and the condition
            // but since XORing q[0] twice cancels out, simplify to q[31] ^ q[21] ^ q[1]
            // So correct feedback = q[0] & 1 (to enable feedback) XORed with taps,
            // but because Galois LFSR feedback is q[0] used to conditionally invert taps, 
            // we implement the shifting carefully below.

            reg [31:0] next_q;

            // Galois LFSR shift right with taps:
            // For each bit i:
            // If bit i is tapped, next_q[i] = q[i+1] ^ q[0]
            // Else next_q[i] = q[i+1]
            // For i=31, next_q[31] = q[0] ^ q[31] if tap else q[0]
            // Actually, since the shift is right, q[31] gets new bit which is the feedback bit.
            // But Galois LFSR defines the taps as bit positions which XOR with q[0].

            // Implement directly:
            next_q[31] = q[0] ^ q[31]; // tap at bit 32
            next_q[30] = q[31];
            next_q[29] = q[30];
            next_q[28] = q[29];
            next_q[27] = q[28];
            next_q[26] = q[27];
            next_q[25] = q[26];
            next_q[24] = q[25];
            next_q[23] = q[24];
            next_q[22] = q[23] ^ q[0]; // tap at bit 22
            next_q[21] = q[22];
            next_q[20] = q[21];
            next_q[19] = q[20];
            next_q[18] = q[19];
            next_q[17] = q[18];
            next_q[16] = q[17];
            next_q[15] = q[16];
            next_q[14] = q[15];
            next_q[13] = q[14];
            next_q[12] = q[13];
            next_q[11] = q[12];
            next_q[10] = q[11];
            next_q[9]  = q[10];
            next_q[8]  = q[9];
            next_q[7]  = q[8];
            next_q[6]  = q[7];
            next_q[5]  = q[6];
            next_q[4]  = q[5];
            next_q[3]  = q[4];
            next_q[2]  = q[3] ^ q[0]; // tap at bit 2
            next_q[1]  = q[2];
            next_q[0]  = q[1] ^ q[0]; // tap at bit 1

            q <= next_q;
        end
    end

endmodule