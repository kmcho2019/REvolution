module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tapped bit positions: 32, 22, 2, and 1 correspond to q[31], q[21], q[1], q[0].
    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Extract feedback from LSB
            wire fb = q[0];
            
            // Compute next state bits explicitly
            // Shift right by 1 and conditionally XOR tapped bits with feedback
            q[31] <= q[30] ^ fb;         // Tap at bit 32
            q[30] <= q[29];
            q[29] <= q[28];
            q[28] <= q[27];
            q[27] <= q[26];
            q[26] <= q[25];
            q[25] <= q[24];
            q[24] <= q[23];
            q[23] <= q[22];
            q[22] <= q[21] ^ fb;         // Tap at bit 22
            q[21] <= q[20];
            q[20] <= q[19];
            q[19] <= q[18];
            q[18] <= q[17];
            q[17] <= q[16];
            q[16] <= q[15];
            q[15] <= q[14];
            q[14] <= q[13];
            q[13] <= q[12];
            q[12] <= q[11];
            q[11] <= q[10];
            q[10] <= q[9];
            q[9]  <= q[8];
            q[8]  <= q[7];
            q[7]  <= q[6];
            q[6]  <= q[5];
            q[5]  <= q[4];
            q[4]  <= q[3];
            q[3]  <= q[2];
            q[2]  <= q[1] ^ fb;          // Tap at bit 2
            q[1]  <= q[0] ^ fb;          // Tap at bit 1
            q[0]  <= fb;                 // LSB feeds itself (original LSB)
        end
    end

endmodule