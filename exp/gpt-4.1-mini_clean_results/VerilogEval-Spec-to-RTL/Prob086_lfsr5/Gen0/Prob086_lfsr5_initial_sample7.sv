module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    // On reset, initialize to 1
    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Compute feedback bit from taps (bits 5 and 3 correspond to q[4] and q[2])
            // XOR with outgoing bit q[0]
            // In Galois LFSR, bit with tap is XORed with q[0]
            // The bits are updated from MSB to LSB as per Galois structure:
            // q[4] <= q[4] ^ q[0]
            // q[3] <= q[3]
            // q[2] <= q[2] ^ q[0]
            // q[1] <= q[1]
            // q[0] <= q[0] shifted out from q[1]
            // But since shift right, q[0] <= q[1]
            
            // Save q[0]
            wire feedback = q[0];

            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ feedback; // tap at bit 3
            q[3] <= q[4];
            q[4] <= q[4] ^ feedback; // tap at bit 5
        end
    end

endmodule