module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions: bits 31, 21, 1, and 0 (0-based)
    // The feedback is q[0] XOR q[21] XOR q[1] XOR q[0] again, 
    // but since q[0] repeats, use q[0] XOR q[21] XOR q[1] only
    // Actually for Galois LFSR, feedback = q[0];
    // And the bits at the tap positions are XORed with feedback during shift.
    
    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            wire feedback = q[0];
            q[0] <= q[1];
            q[1] <= q[2] ^ feedback;       // tap at bit 2
            q[2] <= q[3];
            q[3] <= q[4];
            q[4] <= q[5];
            q[5] <= q[6];
            q[6] <= q[7];
            q[7] <= q[8];
            q[8] <= q[9];
            q[9] <= q[10];
            q[10] <= q[11];
            q[11] <= q[12];
            q[12] <= q[13];
            q[13] <= q[14];
            q[14] <= q[15];
            q[15] <= q[16];
            q[16] <= q[17];
            q[17] <= q[18];
            q[18] <= q[19];
            q[19] <= q[20];
            q[20] <= q[21] ^ feedback;     // tap at bit 22
            q[21] <= q[22];
            q[22] <= q[23];
            q[23] <= q[24];
            q[24] <= q[25];
            q[25] <= q[26];
            q[26] <= q[27];
            q[27] <= q[28];
            q[28] <= q[29];
            q[29] <= q[30];
            q[30] <= q[31];
            q[31] <= feedback;             // tap at bit 32 (MSB)
        end
    end

endmodule