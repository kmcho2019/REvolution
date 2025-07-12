module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    wire [31:0] next_q;

    // Compute next state bits
    assign next_q[31] = q[30] ^ feedback; // tap at bit 32 (index 31)
    assign next_q[30] = q[29];
    assign next_q[29] = q[28];
    assign next_q[28] = q[27];
    assign next_q[27] = q[26];
    assign next_q[26] = q[25];
    assign next_q[25] = q[24];
    assign next_q[24] = q[23];
    assign next_q[23] = q[22];
    assign next_q[22] = q[21] ^ feedback; // tap at bit 22 (index 21)
    assign next_q[21] = q[20];
    assign next_q[20] = q[19];
    assign next_q[19] = q[18];
    assign next_q[18] = q[17];
    assign next_q[17] = q[16];
    assign next_q[16] = q[15];
    assign next_q[15] = q[14];
    assign next_q[14] = q[13];
    assign next_q[13] = q[12];
    assign next_q[12] = q[11];
    assign next_q[11] = q[10];
    assign next_q[10] = q[9];
    assign next_q[9]  = q[8];
    assign next_q[8]  = q[7];
    assign next_q[7]  = q[6];
    assign next_q[6]  = q[5];
    assign next_q[5]  = q[4];
    assign next_q[4]  = q[3];
    assign next_q[3]  = q[2];
    assign next_q[2]  = q[1] ^ feedback; // tap at bit 2 (index 1)
    assign next_q[1]  = q[0] ^ feedback; // tap at bit 1 (index 0)
    assign next_q[0]  = q[0];             // shift right, LSB gets old q[0] (shifted out bit)

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule