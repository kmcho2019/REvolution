module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback;
    assign feedback = q[0]; // LSB feedback bit

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q[31] <= feedback;

            // Bit 30 (corresponds to bit 31 tap?) check tap at bit 31 (1-based)
            // taps at bits 32,22,2,1 -> zero-based 31,21,1,0
            q[30] <= q[31] ^ feedback;  // bit 31 is a tap -> XOR feedback

            // bit 29 is not a tap
            q[29] <= q[30];

            // bit 28 not a tap
            q[28] <= q[29];

            // bit 27 not a tap
            q[27] <= q[28];

            // bit 26 not a tap
            q[26] <= q[27];

            // bit 25 not a tap
            q[25] <= q[26];

            // bit 24 not a tap
            q[24] <= q[25];

            // bit 23 not a tap
            q[23] <= q[24];

            // bit 22 IS a tap (zero-based 21)
            q[22] <= q[23] ^ feedback;

            // bit 21 not a tap
            q[21] <= q[22];

            // bit 20 not a tap
            q[20] <= q[21];

            // bit 19 not a tap
            q[19] <= q[20];

            // bit 18 not a tap
            q[18] <= q[19];

            // bit 17 not a tap
            q[17] <= q[18];

            // bit 16 not a tap
            q[16] <= q[17];

            // bit 15 not a tap
            q[15] <= q[16];

            // bit 14 not a tap
            q[14] <= q[15];

            // bit 13 not a tap
            q[13] <= q[14];

            // bit 12 not a tap
            q[12] <= q[13];

            // bit 11 not a tap
            q[11] <= q[12];

            // bit 10 not a tap
            q[10] <= q[11];

            // bit 9 not a tap
            q[9] <= q[10];

            // bit 8 not a tap
            q[8] <= q[9];

            // bit 7 not a tap
            q[7] <= q[8];

            // bit 6 not a tap
            q[6] <= q[7];

            // bit 5 not a tap
            q[5] <= q[6];

            // bit 4 not a tap
            q[4] <= q[5];

            // bit 3 not a tap
            q[3] <= q[4];

            // bit 2 IS a tap (zero-based 1)
            q[2] <= q[3] ^ feedback;

            // bit 1 not a tap
            q[1] <= q[2];

            // bit 0 IS a tap (zero-based 0)
            q[0] <= q[1] ^ feedback;
        end
    end

endmodule