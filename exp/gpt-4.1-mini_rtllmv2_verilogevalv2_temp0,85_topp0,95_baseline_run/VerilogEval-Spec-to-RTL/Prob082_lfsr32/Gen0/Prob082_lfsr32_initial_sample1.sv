module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Extract the feedback bit (LSB before shift)
            wire fb = q[0];

            // Prepare next state
            // Shift right by one bit
            // For tapped bits, XOR with fb
            // Bit positions in zero-based indexing: 31, 21, 1, 0 correspond to taps at bits 32,22,2,1 respectively
            q <= { 
                q[31] ^ fb,  // bit 31 (tap)
                q[30:22],
                q[21] ^ fb,  // bit 21 (tap)
                q[20:2],
                q[1]  ^ fb,  // bit 1 (tap)
                q[0]         // bit 0 (tap)
            } >> 1;
            
            // The above is not correct since q is 32 bits.
            // Let's implement carefully:

            // The Galois LFSR updates each bit as:
            // For bits that are tapped, the next bit is current bit XOR feedback bit (q[0])
            // For other bits, the next bit is the bit to the left

            // Compute next q bits
            reg [31:0] next_q;
            next_q[31] = q[31] ^ fb;   // tap at bit 31 (bit 32)
            next_q[30] = q[31];        // shift right from bit 31
            next_q[29] = q[30];
            next_q[28] = q[29];
            next_q[27] = q[28];
            next_q[26] = q[27];
            next_q[25] = q[26];
            next_q[24] = q[25];
            next_q[23] = q[24];
            next_q[22] = q[21] ^ fb;   // tap at bit 21 (bit 22)
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
            next_q[2]  = q[1] ^ fb;    // tap at bit 1 (bit 2)
            next_q[1]  = q[2];
            next_q[0]  = q[1] ^ fb;    // tap at bit 0 (bit 1)

            q <= next_q;
        end
    end
endmodule