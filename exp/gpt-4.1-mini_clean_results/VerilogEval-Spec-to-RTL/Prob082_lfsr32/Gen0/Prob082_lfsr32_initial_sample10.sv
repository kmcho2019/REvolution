module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

    // On reset synchronous, q <= 1
    // On each clock cycle, perform Galois LFSR step

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Calculate the feedback bit, which is q[0]
            wire fb = q[0];

            // Create next state
            // For Galois LFSR, bits shift right; tapped bits are XORed with feedback bit

            // Bit positions (indexing 0..31):
            // taps at bits 31, 21, 1, and 0
            // For each bit:
            // - If tapped and fb==1, next bit = q[bit+1] ^ 1 (toggle)
            // - else next bit = q[bit+1]

            // Because shifting right, next q[31] <= fb
            // For other bits:
            // q[i] = q[i+1] ^ (fb & tap_at_i)

            // tap vector (32 bits) with '1' at tapped positions:
            // Positions: 31,21,1,0
            localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

            integer i;
            reg [31:0] next_q;

            next_q[31] = fb;
            for (i=30; i>=0; i=i-1) begin
                // If tap at i, XOR with fb; else just shift from q[i+1]
                next_q[i] = q[i+1] ^ (fb & TAP_MASK[i]);
            end

            q <= next_q;
        end
    end

endmodule