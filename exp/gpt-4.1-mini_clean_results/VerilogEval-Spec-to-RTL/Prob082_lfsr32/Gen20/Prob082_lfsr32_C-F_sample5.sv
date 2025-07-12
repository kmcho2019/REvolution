module TopModule (
    input  clk,
    input  reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            wire feedback = q[0];
            reg [31:0] next_q;

            // MSB bit 31: tap, XOR with feedback
            next_q[31] = q[31] ^ feedback; // shifted in bit is q[31] xor feedback per Galois LFSR

            // Bits 30 down to 22: shift right normally (no tap)
            next_q[30:22] = q[31:23];

            // Bit 21: tap, XOR with feedback
            next_q[21] = q[21] ^ feedback;

            // Bits 20 down to 2: shift right normally (no tap)
            next_q[20:2] = q[20:2] >> 1; // Actually shift q[21:3] one to the right, for clarity:
            // Instead assign directly:
            next_q[20:2] = q[21:3];

            // Bit 1: tap, XOR with feedback
            next_q[1] = q[1] ^ feedback;

            // Bit 0: tap, XOR with feedback
            next_q[0] = q[0] ^ feedback;

            q <= next_q;
        end
    end

endmodule