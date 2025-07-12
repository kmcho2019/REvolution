module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    wire [31:0] next_q;

    // Compute next state bit-by-bit for Galois LFSR with taps at bits 31,21,1,0 (0-based)
    // next_q[31] = q[0] ^ q[31] (since tap at bit 32)
    // bits with taps XOR feedback; others shift in the value from the bit above
    assign next_q[31] = q[31] ^ feedback;
    assign next_q[30] = q[31];
    assign next_q[29] = q[30];
    assign next_q[28] = q[29];
    assign next_q[27] = q[28];
    assign next_q[26] = q[27];
    assign next_q[25] = q[26];
    assign next_q[24] = q[25];
    assign next_q[23] = q[24];
    assign next_q[22] = q[23] ^ feedback; // tap at bit 22
    assign next_q[21] = q[22];
    assign next_q[20] = q[21];
    assign next_q[19] = q[20];
    assign next_q[18] = q[19];
    assign next_q[17] = q[18];
    assign next_q[16] = q[17];
    assign next_q[15] = q[16];
    assign next_q[14] = q[15];
    assign next_q[13] = q[14];
    assign next_q[12] = q[13];
    assign next_q[11] = q[12];
    assign next_q[10] = q[11];
    assign next_q[9]  = q[10];
    assign next_q[8]  = q[9];
    assign next_q[7]  = q[8];
    assign next_q[6]  = q[7];
    assign next_q[5]  = q[6];
    assign next_q[4]  = q[5];
    assign next_q[3]  = q[4];
    assign next_q[2]  = q[3] ^ feedback;  // tap at bit 2
    assign next_q[1]  = q[2] ^ feedback;  // tap at bit 1
    assign next_q[0]  = q[1];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule