module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Calculate feedback: XOR of q[0], q[4], and q[2]
            // In Galois LFSR, bits with taps XOR with LSB (q[0])
            // Implementing this as shifting right with taps XORed.
            // The standard Galois LFSR update for each bit:
            // q[4] <= q[0] ^ q[4] (tap)
            // q[3] <= q[4]
            // q[2] <= q[0] ^ q[2] (tap)
            // q[1] <= q[2]
            // q[0] <= q[1]
            //
            // We must be careful to use previous q values for update:
            // Compute next values:
            q <= {q[0] ^ q[4], q[4], q[0] ^ q[2], q[2], q[1]};
        end
    end

endmodule