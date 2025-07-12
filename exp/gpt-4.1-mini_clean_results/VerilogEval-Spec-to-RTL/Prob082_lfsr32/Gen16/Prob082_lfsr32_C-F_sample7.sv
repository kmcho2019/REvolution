module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Extract feedback bit
            wire fb = q[0];

            // Shift right by one and apply XOR feedback only to tapped bits
            // Tapped bits: 31,21,1,0 (zero-based)
            q[31] <= fb;                       // tap at bit 31
            q[30] <= q[31];                   // no tap
            q[29] <= q[30];                   // no tap
            q[28] <= q[29];                   // no tap
            q[27] <= q[28];                   // no tap
            q[26] <= q[27];                   // no tap
            q[25] <= q[26];                   // no tap
            q[24] <= q[25];                   // no tap
            q[23] <= q[24];                   // no tap
            q[22] <= q[23] ^ fb;              // tap at bit 21
            q[21] <= q[22];                   // no tap
            q[20] <= q[21];                   // no tap
            q[19] <= q[20];                   // no tap
            q[18] <= q[19];                   // no tap
            q[17] <= q[18];                   // no tap
            q[16] <= q[17];                   // no tap
            q[15] <= q[16];                   // no tap
            q[14] <= q[15];                   // no tap
            q[13] <= q[14];                   // no tap
            q[12] <= q[13];                   // no tap
            q[11] <= q[12];                   // no tap
            q[10] <= q[11];                   // no tap
            q[9]  <= q[10];                   // no tap
            q[8]  <= q[9];                    // no tap
            q[7]  <= q[8];                    // no tap
            q[6]  <= q[7];                    // no tap
            q[5]  <= q[6];                    // no tap
            q[4]  <= q[5];                    // no tap
            q[3]  <= q[4];                    // no tap
            q[2]  <= q[3];                    // no tap
            q[1]  <= q[2] ^ fb;               // tap at bit 1
            q[0]  <= q[1] ^ fb;               // tap at bit 0 (LSB)
        end
    end
endmodule