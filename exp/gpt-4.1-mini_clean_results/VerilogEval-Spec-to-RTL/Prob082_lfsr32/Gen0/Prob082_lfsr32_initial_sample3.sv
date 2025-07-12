module TopModule (
    input  wire        clk,
    input  wire        reset,
    output reg [31:0]  q
);
    // Taps at bits 32, 22, 2, 1 => q[31], q[21], q[1], q[0]
    // Galois LFSR shifts right, feedback from q[0] XORed with taps
    
    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h00000001;
        end else begin
            // Compute feedback bit: xor of q[0] with tapped bits q[31], q[21], q[1]
            wire feedback = q[0] ^ q[31] ^ q[21] ^ q[1];
            // Shift right and apply feedback to tapped positions
            // The feedback affects bits where taps are present (except q[0])
            q <= {q[30:0], 1'b0}; // shift right by 1 bit, MSB zero temporarily
            // Now apply feedback to tapped bits:
            // Because this is Galois LFSR, bits at tap positions are xor'ed with feedback,
            // but bits shift right anyway.
            // However, in Galois configuration, the LFSR is updated bit-by-bit:
            // q[i] = q[i+1] if no tap; q[i] = q[i+1]^feedback if tap
            // We'll build the new q value accordingly.

            // To implement this cleanly, calculate next q combinationally first:
            reg [31:0] next_q;
            integer i;
            begin
                // q[0] = q[1]
                next_q[0] = q[1];
                // For bits 1 to 30:
                for (i = 1; i < 31; i = i +1) begin
                    // If tap: i == 0-based 31, 21, 1, or 0? taps are at bits 31,21,1,0
                    // We only handle i=1..30 here:
                    if ((i == 21) || (i == 1)) begin
                        next_q[i] = q[i+1] ^ feedback;
                    end else begin
                        next_q[i] = q[i+1];
                    end
                end
                // For i=31 (MSB):
                // Tap at 31, so XOR with feedback:
                next_q[31] = q[0] ^ feedback; // Wait q[32] does not exist, shift right by 1 means q[31] = feedback?
                // Correction: since shifting right, q[31] <= feedback
                // Actually, LFSR shifts right: q[i] = q[i+1] xor feedback if tap, else q[i+1]
                // Since q[32] doesn't exist, q[31] <= feedback (tap bit)
            end
            q <= next_q;
        end
    end

endmodule