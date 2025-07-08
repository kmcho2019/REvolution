module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    wire tap_xor;

    // Calculate XOR of tapped bits (except LSB)
    wire tap_31 = q[31];
    wire tap_21 = q[21];
    wire tap_1  = q[1];

    // For Galois LFSR, bits with taps XOR with feedback to produce next state
    // For bits without taps, just shift right

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by 1 bit, but apply XOR for tapped bits
            // q[31] <= q[30] ^ feedback if tapped
            // Actually, we handle this carefully:

            q[31] <= q[30] ^ feedback;          // tap at bit 32 (q[31])
            q[30] <= q[29];
            q[29] <= q[28];
            q[28] <= q[27];
            q[27] <= q[26];
            q[26] <= q[25];
            q[25] <= q[24];
            q[24] <= q[23];
            q[23] <= q[22];
            q[22] <= q[21] ^ feedback;          // tap at bit 22 (q[21])
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
            q[2]  <= q[1] ^ feedback;           // tap at bit 2 (q[1])
            q[1]  <= q[0] ^ feedback;           // tap at bit 1 (q[0])
            q[0]  <= feedback;                  // LSB receives feedback, but since it shifts right, LSB is feedback
        end
    end

endmodule