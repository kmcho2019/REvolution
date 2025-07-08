module TopModule (
    input  wire clk,
    input  wire reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // feedback bit is q[0]
            wire feedback = q[0];

            // Compute next state
            // For tapped bits (31,21,1,0), next bit = q[i-1] ^ feedback
            // For untapped bits, next bit = q[i-1]

            // Create next_q for clarity
            reg [31:0] next_q;
            integer i;

            // MSB (bit 31)
            // tapped at bit 32 (index 31)
            next_q[31] = q[30] ^ feedback;

            // bits 30 down to 22 (index 30 down to 21) untapped
            for (i = 30; i > 21; i = i -1) begin
                next_q[i] = q[i-1];
            end

            // bit 21 tapped (bit 22)
            next_q[21] = q[20] ^ feedback;

            // bits 20 down to 2 untapped except bit 1 tapped (index 1), bit 0 tapped (index 0)
            for (i = 20; i > 1; i = i - 1) begin
                next_q[i] = q[i-1];
            end

            // bit 1 tapped
            next_q[1] = q[0] ^ feedback;

            // bit 0 tapped
            // LSB shifts in q[-1], which is undefined, so next_q[0] = feedback (LSB is feedback)
            // But in a Galois LFSR, the LSB is just the previous bit 1 (shift right),
            // but since it's tapped, next_q[0] = q[-1] ^ feedback, which is q[-1] undefined.
            // Actually, for bit 0, no bit to shift from, so next_q[0] = feedback
            next_q[0] = feedback;

            q <= next_q;
        end
    end
endmodule