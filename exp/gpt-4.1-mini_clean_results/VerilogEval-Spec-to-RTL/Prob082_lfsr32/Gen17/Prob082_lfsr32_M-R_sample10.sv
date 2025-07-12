module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    wire fb = q[0];
    wire [31:0] next_q;

    // Bit 31 is next q[31], shifted in from feedback
    // For tapped bits (31, 21, 1, 0 in zero-based index), apply XOR with fb
    assign next_q[31] = q[31-1] ^ fb;      // bit 32 tap -> q[31]
    assign next_q[30:22] = q[30:22-1];     // bits 30 down to 22 shift right by 1 with no tap
    assign next_q[21] = q[21-1] ^ fb;      // bit 22 tap -> q[21]
    assign next_q[20:2] = q[20:2-1];       // bits 20 down to 2 shift right by 1 with no tap
    assign next_q[1] = q[1-1] ^ fb;        // bit 2 tap -> q[1]
    assign next_q[0] = q[0-1] ^ fb;        // bit 1 tap -> q[0], but q[-1] invalid, so shift from q[0]?

    // Note: Since q is 32 bits 0..31, q[-1] is invalid. For bit 0:
    // LFSR shifts right, so q[0] is LSB.
    // The next q[0] is just the feedback bit from outside the register (for Galois it's always q[1] shifted to q[0]).
    // Actually, in a Galois LFSR shifting right, q[0] is replaced by feedback from tapped bits XOR q[0].
    // But by definition, the next q[0] is q[1], unless q[0] == 1, then q[1]^fb.

    // To avoid confusion, it's better to rewrite all bits from 31 down to 0, carefully applying the taps.

    // More straightforward: manually assign each bit:

    assign next_q[0] = q[1];                              // no tap on bit 0, just shift right
    assign next_q[1] = q[2] ^ (fb ? 1'b1 : 1'b0);       // tap at bit 2 (q[2]) XOR feedback when fb==1
    assign next_q[2] = q[3];                              // no tap on bit 3
    assign next_q[3] = q[4];                              // no tap
    assign next_q[4] = q[5];                              // no tap
    assign next_q[5] = q[6];                              // no tap
    assign next_q[6] = q[7];                              // no tap
    assign next_q[7] = q[8];                              // no tap
    assign next_q[8] = q[9];                              // no tap
    assign next_q[9] = q[10];                             // no tap
    assign next_q[10] = q[11];                            // no tap
    assign next_q[11] = q[12];                            // no tap
    assign next_q[12] = q[13];                            // no tap
    assign next_q[13] = q[14];                            // no tap
    assign next_q[14] = q[15];                            // no tap
    assign next_q[15] = q[16];                            // no tap
    assign next_q[16] = q[17];                            // no tap
    assign next_q[17] = q[18];                            // no tap
    assign next_q[18] = q[19];                            // no tap
    assign next_q[19] = q[20];                            // no tap
    assign next_q[20] = q[21];                            // no tap
    assign next_q[21] = q[22] ^ (fb ? 1'b1 : 1'b0);      // tap at bit 22
    assign next_q[22] = q[23];                            // no tap
    assign next_q[23] = q[24];                            // no tap
    assign next_q[24] = q[25];                            // no tap
    assign next_q[25] = q[26];                            // no tap
    assign next_q[26] = q[27];                            // no tap
    assign next_q[27] = q[28];                            // no tap
    assign next_q[28] = q[29];                            // no tap
    assign next_q[29] = q[30];                            // no tap
    assign next_q[30] = q[31];                            // no tap
    assign next_q[31] = fb;                               // tap at bit 32 position means feedback is fed to MSB

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end
endmodule