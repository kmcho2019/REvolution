module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);
    wire feedback;
    reg [31:0] next_q;

    // Calculate the feedback bit: XOR of taps q[31], q[21], q[1], and q[0]
    assign feedback = q[0] ^ q[1] ^ q[21] ^ q[31];

    always @* begin
        // Compute next state for each bit according to Galois LFSR rules
        next_q[31] = q[30] ^ feedback;   // tap at bit 31 (bit 32 one-based)
        next_q[30] = q[29];              // no tap
        next_q[29] = q[28];              // no tap
        next_q[28] = q[27];              // no tap
        next_q[27] = q[26];              // no tap
        next_q[26] = q[25];              // no tap
        next_q[25] = q[24];              // no tap
        next_q[24] = q[23];              // no tap
        next_q[23] = q[22];              // no tap
        next_q[22] = q[21] ^ feedback;   // tap at bit 21 (bit 22 one-based)
        next_q[21] = q[20];              // no tap
        next_q[20] = q[19];              // no tap
        next_q[19] = q[18];              // no tap
        next_q[18] = q[17];              // no tap
        next_q[17] = q[16];              // no tap
        next_q[16] = q[15];              // no tap
        next_q[15] = q[14];              // no tap
        next_q[14] = q[13];              // no tap
        next_q[13] = q[12];              // no tap
        next_q[12] = q[11];              // no tap
        next_q[11] = q[10];              // no tap
        next_q[10] = q[9];               // no tap
        next_q[9]  = q[8];               // no tap
        next_q[8]  = q[7];               // no tap
        next_q[7]  = q[6];               // no tap
        next_q[6]  = q[5];               // no tap
        next_q[5]  = q[4];               // no tap
        next_q[4]  = q[3];               // no tap
        next_q[3]  = q[2];               // no tap
        next_q[2]  = q[1] ^ feedback;   // tap at bit 1 (bit 2 one-based)
        next_q[1]  = q[0] ^ feedback;   // tap at bit 0 (bit 1 one-based)
        next_q[0]  = feedback;           // LSB gets feedback bit
    end

    always @(posedge clk) begin
        if (reset) 
            q <= 32'h1;
        else 
            q <= next_q;
    end
endmodule