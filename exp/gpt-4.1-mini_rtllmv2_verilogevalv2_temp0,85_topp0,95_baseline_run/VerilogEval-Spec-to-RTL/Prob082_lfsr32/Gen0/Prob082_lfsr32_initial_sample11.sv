module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Calculate the feedback bit (x)
            wire feedback = q[0];
            // Next state bits calculation
            // For Galois LFSR:
            // q[31] <= q[31] ^ feedback (tap at bit 32)
            // q[21] <= q[21] ^ feedback (tap at bit 22)
            // q[1]  <= q[1]  ^ feedback (tap at bit 2)
            // q[0]  <= q[0]  ^ feedback (tap at bit 1) but since q[0] is output bit, it shifts out, so next q[0] <= q[1] (with xor if tap)
            // Actually, the LSB shifts out, the new bits are formed by shifting right, with taps modifying bits.

            // We'll build next_q bit by bit
            reg [31:0] next_q;

            // Bit 31 (MSB) gets q[31] ^ feedback
            next_q[31] = q[31] ^ feedback;

            // For bits from 30 down to 0:
            // if tap, next_q[i] = q[i] ^ feedback
            // else next_q[i] = q[i+1]
            integer i;
            for (i = 30; i >= 0; i = i - 1) begin
                if ((i == 21) || (i == 1) || (i == 0)) begin
                    next_q[i] = q[i] ^ feedback;
                end else begin
                    next_q[i] = q[i+1];
                end
            end

            q <= next_q;
        end
    end

endmodule