module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Define tap positions as a mask for bits 31, 21, 1, 0 (0-based)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    integer i;
    reg feedback;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            feedback = q[0]; // LSB is the feedback bit
            // Shift right by one, applying tap XOR with feedback
            // We'll build the next q value bit-by-bit
            reg [31:0] next_q;
            // bit 0 gets the feedback directly from bit 1 before shift
            // Actually in Galois LFSR, bit 0 = bit 1 XOR (tap_bit * feedback) but bit 0 is LSB after shift,
            // here the feedback determines bits 31,21,1,0 updates, so we treat bits carefully
            // Instead of explaining this ambiguous bit 0, we implement as:
            // For bits 31 down to 1: 
            // if bit is a tap, q[i] = q[i-1] XOR feedback
            // else q[i] = q[i-1]
            // For bit 0, it's just q[0] = feedback (to maintain correct sequence)
            next_q[0] = feedback;
            for (i = 1; i < 32; i = i + 1) begin
                if (TAP_MASK[i])
                    next_q[i] = q[i-1] ^ feedback;
                else
                    next_q[i] = q[i-1];
            end
            q <= next_q;
        end
    end

endmodule