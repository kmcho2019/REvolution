module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    wire tap_32 = q[31] ^ feedback;
    wire tap_22 = q[21] ^ feedback;
    wire tap_2  = q[1]  ^ feedback;
    wire tap_1  = q[0]  ^ feedback; // This is q[0] ^ q[0] = 0, no effect, but kept for clarity

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            // For Galois LFSR, bits with taps XOR with feedback, others shift right unchanged.
            // Update bits from MSB (31) down to 0:
            // Bit 31 (tap_32) gets q[31]^feedback
            // Bit 21 (tap_22) gets q[21]^feedback
            // Bit 1  (tap_2)  gets q[1]^feedback
            // Bit 0  (tap_1)  is q[0]^feedback but feedback=q[0], so zero - next bit0 is zero always.
            // All other bits shift right from previous bit.
            q[31] <= tap_32;
            q[30] <= q[31];
            q[29] <= q[30];
            q[28] <= q[29];
            q[27] <= q[28];
            q[26] <= q[27];
            q[25] <= q[26];
            q[24] <= q[25];
            q[23] <= q[24];
            q[22] <= tap_22;
            q[21] <= q[22];
            q[20] <= q[21];
            q[19] <= q[20];
            q[18] <= q[19];
            q[17] <= q[18];
            q[16] <= q[17];
            q[15] <= q[16];
            q[14] <= q[15];
            q[13] <= q[14];
            q[12] <= q[13];
            q[11] <= q[12];
            q[10] <= q[11];
            q[9]  <= q[10];
            q[8]  <= q[9];
            q[7]  <= q[8];
            q[6]  <= q[7];
            q[5]  <= q[6];
            q[4]  <= q[5];
            q[3]  <= q[4];
            q[2]  <= q[3];
            q[1]  <= tap_2;
            q[0]  <= feedback; // This is q[0], shifted right from q[1] normally, but with tap at bit 1 XOR with feedback
        end
    end

endmodule