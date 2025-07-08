module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // reset to 1
        end else begin
            // Galois LFSR taps at bit 5 (q[4]) and bit 3 (q[2])
            // feedback is q[0]
            // shift right: q[4] <= q[3], q[3] <= q[2], q[2] <= q[1], q[1] <= q[0], q[0] <= feedback
            // For tapped bits, next bit = previous bit XOR q[0]
            // So we apply XOR only at positions 5 and 3 (q[4] and q[2])
            // q[4] = q[3] ^ q[0]
            // q[3] = q[2]
            // q[2] = q[1] ^ q[0]
            // q[1] = q[0]
            // q[0] = q[0] (shifted in bit is usually the output bit itself in Galois)
            // Actually, in Galois LFSR, the input bit is just q[0], and taps modify the shifted bits

            wire feedback = q[0];
            q[4] <= q[3] ^ feedback;
            q[3] <= q[2];
            q[2] <= q[1] ^ feedback;
            q[1] <= q[0];
            q[0] <= feedback;
        end
    end

endmodule